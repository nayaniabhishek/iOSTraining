package com.example.nayani.todos;

import com.raizlabs.android.dbflow.annotation.Column;
import com.raizlabs.android.dbflow.annotation.PrimaryKey;
import com.raizlabs.android.dbflow.annotation.Table;
import com.raizlabs.android.dbflow.structure.BaseModel;

/**
 * Created by nayani on 1/11/17.
 */

@Table(database = MyDatabase.class)
public class ToDo extends BaseModel {
    @PrimaryKey
    @Column
    String title;

    @Override
    public String toString() {
        return title;
    }
}
