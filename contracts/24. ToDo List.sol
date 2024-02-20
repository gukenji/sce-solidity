// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TodoList {
    struct Todo {
        string text;
        bool completed;
    }

    Todo[] public todos;

    function create(string calldata text) external {
        Todo memory todo = Todo(text, false);
        todos.push(todo);
    }

    function updateText(uint256 index, string calldata text) external {
        Todo storage todo = todos[index];
        todo.text = text;
    }

    function toggleCompleted(uint256 index) external {
        Todo storage todo = todos[index];
        todo.completed = !todo.completed;
    }

    function get(uint256 index) public view returns (string memory, bool) {
        Todo memory todo = todos[index];
        return (todo.text, todo.completed);
    }
}
