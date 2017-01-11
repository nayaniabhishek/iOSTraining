package com.example.nayani.todos;

import com.raizlabs.android.dbflow.annotation.Database;

/**
 * Created by nayani on 1/11/17.
 */

@Database(name = MyDatabase.NAME, version = MyDatabase.VERSION)
public class MyDatabase {
    public static final String NAME = "MyDataBase";

    public static final int VERSION = 1;
}