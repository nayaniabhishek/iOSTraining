package com.yahoo.nayani.timessearch;

import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SearchView;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.yahoo.nayani.timessearch.adapter.ArticleAdapter;
import com.yahoo.nayani.timessearch.model.Article;
import com.yahoo.nayani.timessearch.model.Settings;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cz.msebera.android.httpclient.Header;

public class MainActivity extends AppCompatActivity implements SettingsDialog.SettingsListener {

    private static final String LOG_TAG = MainActivity.class.getName();
    private static final String URL = "https://api.nytimes.com/svc/search/v2/articlesearch.json";

    //private EditText etQuery;
    private List<Article> articles;
    private RecyclerView rvArticleGrid;
    private RecyclerView.Adapter adapter;
    private Map<String, String> filterParams;
    private String searchQuery;
    private EndlessRecyclerViewScrollListener scrollListener;
    private int page;
    private Settings settings;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        settings = new Settings();

        //etQuery = (EditText) findViewById(etQuery);
        rvArticleGrid = (RecyclerView) findViewById(R.id.rvArticleGrid);

        articles = new ArrayList<>();
        adapter = new ArticleAdapter(getBaseContext(), articles);
        page = 0;

        GridLayoutManager grid = new GridLayoutManager(this, 2);
        rvArticleGrid.setLayoutManager(grid);
        rvArticleGrid.setAdapter(adapter);

        filterParams = new HashMap<>();

        SpacesItemDecoration decoration = new SpacesItemDecoration(16);
        rvArticleGrid.addItemDecoration(decoration);

        ItemClickSupport.addTo(rvArticleGrid).setOnItemClickListener(
                new ItemClickSupport.OnItemClickListener() {
                    @Override
                    public void onItemClicked(RecyclerView recyclerView, int position, View v) {
                        Article article = articles.get(position);

                        //Toast.makeText(getBaseContext(), article.getWebUrl(), Toast.LENGTH_SHORT).show();
                        Intent intent = new Intent(MainActivity.this, NewsView.class);
                        intent.putExtra("url", article.getWebUrl());
                        startActivityForResult(intent, 0);
                    }
                }
        );

        // Retain an instance so that you can call `resetState()` for fresh searches
        scrollListener = new EndlessRecyclerViewScrollListener(grid) {
            @Override
            public void onLoadMore(int page, int totalItemsCount, RecyclerView view) {
                // Triggered only when new data needs to be appended to the list
                // Add whatever code is needed to append new items to the bottom of the list
                MainActivity.this.page = page;
                refreshArticle();
            }
        };
        // Adds the scroll listener to RecyclerView
        rvArticleGrid.addOnScrollListener(scrollListener);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu, menu);

        MenuItem settingsItem = menu.findItem(R.id.action_settings);
        settingsItem.setOnMenuItemClickListener(new MenuItem.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem item) {
                FragmentManager fm = getSupportFragmentManager();
                SettingsDialog dialog = SettingsDialog.newInstance();
                Bundle args = new Bundle();
                args.putParcelable("settings", settings);
                dialog.setArguments(args);
                dialog.show(fm, "fragment_edit_name");

                return true;
            }
        });

        MenuItem searchItem = menu.findItem(R.id.action_search);
        final SearchView searchView = (SearchView) MenuItemCompat.getActionView(searchItem);
        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                searchQuery = query;

                articles.clear();
                adapter.notifyDataSetChanged(); // or notifyItemRangeRemoved
                scrollListener.resetState();
                page = 0;

                refreshArticle();

                // workaround to avoid issues with some emulators and keyboard devices firing twice if a keyboard enter is used
                // see https://code.google.com/p/android/issues/detail?id=24599
                searchView.clearFocus();

                return true;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                return false;
            }
        });
        return super.onCreateOptionsMenu(menu);
    }

    private void refreshArticle() {
        AsyncHttpClient client = new AsyncHttpClient();

        RequestParams params = new RequestParams(filterParams);
        params.put("api-key", "058dbfd6925b4a5bb69a605257c77062");
        params.put("page", page);
        params.put("q", searchQuery);

        client.get(URL, params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {

                //articles.clear();
                try {
                    JSONArray docsArray = response.getJSONObject("response").getJSONArray("docs");
                    articles.addAll(Article.fromJSONArray(docsArray));
                    adapter.notifyDataSetChanged();
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
        });
    }

    @Override
    public void onSettingsSave(Calendar calendar, boolean newest, ArrayList<String> topics) {
        filterParams = new HashMap<>();

        ArrayList<String> filters = new ArrayList<>();
        if (topics.size() > 0) {
            String filter = "news_desk:(";
            for (String topic : topics) {
                filter += "\"" + topic + "\" ";
                filters.add(topic);
            }
            filter += ")";

            filterParams.put("fq", filter);
            settings.setFilters(filters);
        }

        settings.setSortNewestFirst(newest);

        if (newest) {
            filterParams.put("sort", "newest");
        } else {
            filterParams.put("sort", "oldest");
        }

        if (calendar != null) {
            Date date = calendar.getTime();
            SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMdd");
            filterParams.put("begin_date", fmt.format(date));

            settings.setCalendar(calendar);
        }

        refreshArticle();
    }


    public class SpacesItemDecoration extends RecyclerView.ItemDecoration {
        private final int mSpace;
        public SpacesItemDecoration(int space) {
            this.mSpace = space;
        }
        @Override
        public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
            outRect.left = mSpace;
            outRect.right = mSpace;
            outRect.bottom = mSpace;
            // Add top margin only for the first item to avoid double space between items
            if (parent.getChildAdapterPosition(view) == 0)
                outRect.top = mSpace;
        }
    }

}
