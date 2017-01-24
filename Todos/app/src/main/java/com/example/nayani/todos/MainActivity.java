package com.example.nayani.todos;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.raizlabs.android.dbflow.sql.language.SQLite;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    List<ToDo> items;
    ArrayAdapter<ToDo> itemsAdapter;
    ListView lvItems;
    EditText etEditText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        items = new ArrayList<>();
        readItems();

        itemsAdapter = new ToDoAdapter(this, 0);
        //itemsAdapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, items);

        lvItems = (ListView) findViewById(R.id.lvItems);
        lvItems.setAdapter(itemsAdapter);
        lvItems.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                ToDo todo = items.remove(position);
                todo.delete();

                itemsAdapter.notifyDataSetChanged();
                return true;
            }
        });

        lvItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent i = new Intent(MainActivity.this, EditItemActivity.class);
                i.putExtra("todo", items.get(position).title);
                i.putExtra("pos", position);
                startActivityForResult(i, 0);
            }
        });

        etEditText = (EditText) findViewById(R.id.editText);

    }

    public void onAddItem(View view) {
        ToDo todo = new ToDo();
        todo.title = etEditText.getText().toString();
        todo.save();

        itemsAdapter.add(todo);
        etEditText.setText("");
    }

    private void readItems() {
        items = SQLite.select().from(ToDo.class).queryList();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == RESULT_OK && requestCode == 0) {
            String edit = data.getStringExtra("edited");
            int pos = data.getIntExtra("pos", 0);

            ToDo todo = items.get(pos);
            todo.title = edit;

            itemsAdapter.notifyDataSetChanged();

        }
    }


    class ToDoAdapter extends ArrayAdapter<ToDo> {
        public ToDoAdapter(Context context, int resource) {
            super(context, resource);
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            // Get the data item for this position
            ToDo toDo = getItem(position);

            // Check if an existing view is being reused, otherwise inflate the view
            if (convertView == null) {
                convertView = LayoutInflater.from(getContext()).inflate(R.layout.todo_cell, parent, false);
            }

            // Lookup view for data population
            TextView title = (TextView) convertView.findViewById(R.id.todoTextView);
            TextView priority = (TextView) convertView.findViewById(R.id.priorityTextView);

            // Populate the data into the template view using the data object
            title.setText(toDo.title);
            priority.setText("High");

            // Return the completed view to render on screen
            return convertView;
        }

    }

}