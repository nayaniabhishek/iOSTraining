package com.yahoo.nayani.timessearch.model;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by nayani on 1/30/17.
 */

public class Article {

    private String headline;
    private String webUrl;
    private String thumbnail;

    private Article(JSONObject articleJson) throws JSONException {
        this.headline = articleJson.getJSONObject("headline").optString("main");
        this.webUrl = articleJson.optString("web_url");
        this.thumbnail = null;

        JSONArray multimedia = articleJson.getJSONArray("multimedia");
        if (multimedia != null && multimedia.length() > 0) {
            JSONObject obj = multimedia.getJSONObject(0);
            this.thumbnail = "http://www.nytimes.com/" + obj.optString("url");
        }
    }

    public String getHeadline() {
        return headline;
    }

    public String getWebUrl() {
        return webUrl;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public static List<Article> fromJSONArray(JSONArray responseArray) {
        List<Article> articles = new ArrayList<>();

        for (int i = 0; i < responseArray.length(); i++) {
            try {
                Article article = new Article(responseArray.getJSONObject(i));
                if (article.getThumbnail() != null) {
                    articles.add(article);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        return articles;
    }
}
