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

/**
 * Created by nayani on 1/23/17.
 */

public class MovieArrayAdapter extends ArrayAdapter<Movie> {

    // View lookup cache
    private static class ViewHolder {
        TextView title;
        TextView overview;
        ImageView image;
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

            viewHolder = new ViewHolder();
            viewHolder.title = (TextView) convertView.findViewById(R.id.titleText);
            viewHolder.overview = (TextView) convertView.findViewById(R.id.overviewText);
            viewHolder.image = (ImageView) convertView.findViewById(R.id.landscapePosterView);

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
