package com.yahoo.nayani.timessearch;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;

import java.util.Calendar;

public class DatePickerFragment extends DialogFragment {

    private DatePickerDialog.OnDateSetListener listener;
    private Calendar calendar;

    public DatePickerFragment(DatePickerDialog.OnDateSetListener listener, Calendar calendar) {
        this.listener = listener;
        this.calendar = calendar;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {

        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);

        // Create a new instance of TimePickerDialog and return it
        return new DatePickerDialog(getActivity(), listener, year, month, day);
    }
}