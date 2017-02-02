package com.yahoo.nayani.timessearch;

import android.app.DatePickerDialog;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.DialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.DatePicker;
import android.widget.RadioButton;
import android.widget.TextView;

import com.yahoo.nayani.timessearch.model.Settings;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;


public class SettingsDialog extends DialogFragment implements DatePickerDialog.OnDateSetListener {

    private TextView mEditText;
    private Calendar calendar;
    private Button saveBtn;
    private RadioButton newestFirst;
    private RadioButton oldersFirst;
    private CheckBox arts;
    private CheckBox fashion;
    private CheckBox sports;

    public interface SettingsListener {
        void onSettingsSave(Calendar calendar, boolean newest, ArrayList<String> topics);
    }



    public SettingsDialog() {
        // Empty constructor is required for DialogFragment
        // Make sure not to add arguments to the constructor
        // Use `newInstance` instead as shown below

        calendar = Calendar.getInstance();
    }

    public static SettingsDialog newInstance() {
        SettingsDialog frag = new SettingsDialog();
        return frag;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        return inflater.inflate(R.layout.settings_fragment, container);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        Settings settings = getArguments().getParcelable("settings");

        newestFirst = (RadioButton) view.findViewById(R.id.newestRb);
        oldersFirst = (RadioButton) view.findViewById(R.id.oldestRb);
        arts = (CheckBox) view.findViewById(R.id.artsCb);
        fashion = (CheckBox) view.findViewById(R.id.fashionCb);
        sports = (CheckBox) view.findViewById(R.id.sportsCb);

        // Get field from view
        mEditText = (TextView) view.findViewById(R.id.dateDisplay);

        Date date = (settings.getCalendar() != null) ? settings.getCalendar().getTime() : calendar.getTime();
        SimpleDateFormat fmt = new SimpleDateFormat("MM/dd/yyyy");
        mEditText.setText(fmt.format(date));

        if (settings.isSortNewestFirst()) {
            newestFirst.setChecked(true);
        } else {
            oldersFirst.setChecked(true);
        }

        ArrayList<String> filters = settings.getFilters();
        if (filters.contains("Arts")) {
            arts.setChecked(true);
        }

        if (filters.contains("Fashion & Style")) {
            fashion.setChecked(true);
        }

        if (filters.contains("Sports")) {
            sports.setChecked(true);
        }

        mEditText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                DatePickerFragment newFragment = new DatePickerFragment(SettingsDialog.this, calendar);
                newFragment.show(getActivity().getSupportFragmentManager(), "datePicker");
            }
        });

        saveBtn = (Button) view.findViewById(R.id.saveBn);
        saveBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                boolean isSortNew = newestFirst.isChecked();

                ArrayList<String> filters = new ArrayList<>();
                if (arts.isChecked()) {
                    filters.add("Arts");
                }

                if (fashion.isChecked()) {
                    filters.add("Fashion & Style");
                }

                if (sports.isChecked()) {
                    filters.add("Sports");
                }

                SettingsListener listener = (SettingsListener) getActivity();
                listener.onSettingsSave(calendar, isSortNew, filters);
                dismiss();
            }
        });
    }

    @Override
    public void onResume() {
        super.onResume();

        int width = 900; //getResources().getDimensionPixelSize(R.dimen.popup_width);
        int height = 1200;//getResources().getDimensionPixelSize(R.dimen.popup_height);
        getDialog().getWindow().setLayout(width, height);
    }

    @Override
    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
        // store the values selected into a Calendar instance
        calendar.set(Calendar.YEAR, year);
        calendar.set(Calendar.MONTH, month);
        calendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);


        Date date = calendar.getTime();
        SimpleDateFormat fmt = new SimpleDateFormat("MM/dd/yyyy");
        mEditText.setText(fmt.format(date));
    }
}