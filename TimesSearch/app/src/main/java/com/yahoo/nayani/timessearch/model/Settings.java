package com.yahoo.nayani.timessearch.model;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.ArrayList;
import java.util.Calendar;

/**
 * Created by nayani on 2/2/17.
 */

public class Settings implements Parcelable {
    private Calendar calendar;
    private ArrayList<String> filters;
    private boolean sortNewestFirst;

    public Calendar getCalendar() {
        return calendar;
    }

    public void setCalendar(Calendar calendar) {
        this.calendar = calendar;
    }

    public ArrayList<String> getFilters() {
        return filters;
    }

    public void setFilters(ArrayList<String> filters) {
        this.filters = filters;
    }

    public boolean isSortNewestFirst() {
        return sortNewestFirst;
    }

    public void setSortNewestFirst(boolean sortNewestFirst) {
        this.sortNewestFirst = sortNewestFirst;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeSerializable(this.calendar);
        dest.writeStringList(this.filters);
        dest.writeByte(this.sortNewestFirst ? (byte) 1 : (byte) 0);
    }

    public Settings() {
        this.calendar = null;
        this.filters = new ArrayList<>();
        this.sortNewestFirst = true;
    }

    protected Settings(Parcel in) {
        this.calendar = (Calendar) in.readSerializable();
        this.filters = in.createStringArrayList();
        this.sortNewestFirst = in.readByte() != 0;
    }

    public static final Parcelable.Creator<Settings> CREATOR = new Parcelable.Creator<Settings>() {
        @Override
        public Settings createFromParcel(Parcel source) {
            return new Settings(source);
        }

        @Override
        public Settings[] newArray(int size) {
            return new Settings[size];
        }
    };
}
