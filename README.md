# Todo iOS App (Objective-C)

A iOS ToDo app for organizing and prioritizing daily tasks. Built using **Objective-C**, **UIKit**, and **Xcode**, with local storage via **NSUserDefaults**.

## 📅 Features

* **Add a Task**

  * Input: Task name, description, priority (High, Medium, Low)
  * Input: Task State (Todo, Progress, Done)

* **View Tasks**

  * List of all tasks
  * Filter by status: All, To-Do, In Progress, Done
  * Filter by priority (Each section grouped by priority type)

* **Task Details**

  * View full task info
  * Display reminder details (if any)

* **Edit Task**

  * Update task details with confirmation
  * Optionally edit reminder or attached file (Bonus)

* **Delete Task**

  * Remove a task from the list

* **Mark Task Status**

  * Set as: To-Do, In Progress, Done
  * Constraints:

    * In Progress → Cannot go back to To-Do
    * Done → Cannot go back to In Progress

* **Search Functionality**

  * Search by task name
  * If no results found, a friendly message is displayed

* **Persistent Storage**

  * All tasks and their states are saved locally using `NSUserDefaults`
  * Data is retained between app sessions

## 🌐 Technologies Used

* **Language:** Objective-C
* **UI Framework:** UIKit
* **IDE:** Xcode
* **Local Storage:** NSUserDefaults

## 🚀 Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/TodoApp-ObjectiveC.git
   ```
2. Open the project in **Xcode**
3. Build and run on an iOS simulator or physical device

## 🔧 Bonus Features (Optional)

* Attach and view files in tasks
* Add, edit, and display task reminders

---

A great starter project for learning **Objective-C** and building useful productivity apps on iOS!
