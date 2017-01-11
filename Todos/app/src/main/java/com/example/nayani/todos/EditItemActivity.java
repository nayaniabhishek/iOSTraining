package com.example.nayani.todos;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.EditText;

public class EditItemActivity extends AppCompatActivity {

    EditText editText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_item);

        setTitle("Edit Item");

        editText = (EditText) findViewById(R.id.editText);
        editText.setText(getIntent().getStringExtra("todo"));
        editText.setSelection(editText.getText().length());
    }

    public void onSave(View view) {
        Intent data = new Intent();
        data.putExtra("edited", editText.getText().toString());
        data.putExtra("pos", getIntent().getIntExtra("pos", 0));
        setResult(RESULT_OK, data);
        finish();
    }
}
