package com.yahoo.nayani.flixter.adapters;

import android.content.Context;
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


    public MovieArrayAdapter(Context context, ArrayList<Movie> items) {
        super(context, android.R.layout.simple_list_item_1, items);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        // Get the data item for this position
        Movie movie = getItem(position);

        // Check if an existing view is being reused, otherwise inflate the view
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.portrait_item, parent, false);
        }

        // Lookup view for data population
        TextView title = (TextView) convertView.findViewById(R.id.titleText);
        TextView overview = (TextView) convertView.findViewById(R.id.overviewText);
        ImageView image = (ImageView) convertView.findViewById(R.id.posterView);

        // Populate the data into the template view using the data object
        title.setText(movie.getOriginalTitle());
        overview.setText(movie.getOverView());


        String imageUri = movie.getPosterPath();
        Picasso.with(getContext()).load(imageUri)
                .placeholder(R.mipmap.ic_launcher)
                .into(image);

        // Return the completed view to render on screen
        return convertView;
    }

}
