package com.yahoo.nayani.flixter.models;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by nayani on 1/23/17.
 */

public class Movie {
    private String posterPath;
    private String originalTitle;
    private String overView;
    private String backdropPath;
    private Integer id;

    public Movie(JSONObject jsonObject) throws JSONException {
        this.posterPath = jsonObject.getString("poster_path");
        this.originalTitle = jsonObject.getString("original_title");
        this.overView = jsonObject.getString("overview");
        this.backdropPath = jsonObject.getString("backdrop_path");
        this.id = jsonObject.getInt("id");
    }

    public static ArrayList<Movie> fromJsonArray(JSONArray array) {
        ArrayList<Movie> results = new ArrayList<>();

        for (int i = 0; i < array.length(); i++) {
            try {
                results.add(new Movie(array.getJSONObject(i)));
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        return results;
    }

    public String getPosterPath() {
        return String.format("https://image.tmdb.org/t/p/w342%s", posterPath);
    }

    public String getOriginalTitle() {
        return originalTitle;
    }

    public String getOverView() {
        return overView;
    }

    public String getBackdropPath() {
        return String.format("https://image.tmdb.org/t/p/w780%s", backdropPath);
    }

    public Integer getId() {
        return id;
    }

    @Override
    public String toString() {
        return getOriginalTitle();
    }
}
