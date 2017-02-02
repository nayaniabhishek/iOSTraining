package com.yahoo.nayani.timessearch.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.squareup.picasso.Picasso;
import com.yahoo.nayani.timessearch.R;
import com.yahoo.nayani.timessearch.model.Article;

import java.util.List;

/**
 * Created by nayani on 1/30/17.
 */

public class ArticleAdapter extends RecyclerView.Adapter<ArticleAdapter.ViewHolder> {

    private List<Article> articles;
    private Context context;

    public ArticleAdapter(Context context, List<Article> articles) {
        this.context = context;
        this.articles = articles;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        RelativeLayout layout = (RelativeLayout) LayoutInflater.from(parent.getContext()).inflate(R.layout.article_item, parent, false);

        ViewHolder holder = new ViewHolder(layout);
        return holder;
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        Article currentArticle = articles.get(position);

        holder.headline.setText(currentArticle.getHeadline());

        if (currentArticle.getThumbnail() != null) {
            Picasso.with(context).load(currentArticle.getThumbnail())
                    .placeholder(R.mipmap.ic_launcher)
                    .into(holder.thumbnail);
        } else {
            holder.thumbnail.setVisibility(View.INVISIBLE);
        }
    }

    @Override
    public int getItemCount() {
        return articles.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView headline;
        ImageView thumbnail;

        public ViewHolder(View itemView) {
            super(itemView);

            this.headline = (TextView) itemView.findViewById(R.id.textView);
            this.thumbnail = (ImageView) itemView.findViewById(R.id.imageView);


        }
    }
}
