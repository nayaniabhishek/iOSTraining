package com.yahoo.nayani.flixter.adapters;

import android.content.Context;
import android.content.res.Configuration;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.squareup.picasso.Picasso;
import com.yahoo.nayani.flixter.R;
import com.yahoo.nayani.flixter.models.Movie;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;


public class MovieArrayAdapter extends ArrayAdapter<Movie> {

    // View lookup cache
    static class ViewHolder {
        @BindView(R.id.titleText) TextView title;
        @BindView(R.id.overviewText) TextView overview;
        @BindView(R.id.landscapePosterView) ImageView image;

        public ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
    }


    public MovieArrayAdapter(Context context, ArrayList<Movie> items) {
        super(context, android.R.layout.simple_list_item_1, items);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        // Get the data item for this position
        Movie movie = getItem(position);

        ViewHolder viewHolder;
        // Check if an existing view is being reused, otherwise inflate the view
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.portrait_item, parent, false);

            viewHolder = new ViewHolder(convertView);

            // Cache the viewHolder object inside the fresh view
            convertView.setTag(viewHolder);

        } else {
            // View is being recycled, retrieve the viewHolder object from tag
            viewHolder = (ViewHolder) convertView.getTag();
        }

        // Populate the data into the template view using the data object
        viewHolder.title.setText(movie.getOriginalTitle());
        viewHolder.overview.setText(movie.getOverView());

        String imageUri = movie.getPosterPath();
        int orientation = getContext().getResources().getConfiguration().orientation;
        if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
            imageUri = movie.getBackdropPath();
        }

        Picasso.with(getContext()).load(imageUri)
                .placeholder(R.mipmap.ic_launcher)
                .into(viewHolder.image);

        // Return the completed view to render on screen
        return convertView;
    }

}
