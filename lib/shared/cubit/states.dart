abstract class ToDoAppStates {}

class ToDoAppInitialState extends ToDoAppStates {}

class ToDoAppChangeState extends ToDoAppStates {}

class ToDoAppInsertToDataBase extends ToDoAppStates {}

class ToDoAppGetFromDataBase extends ToDoAppStates {}

class ToDoAppCreateDataBase extends ToDoAppStates {}

class ToDoAppChangeBottomSheet extends ToDoAppStates {}

class ToDoAppLoadingGetFromDataBase extends ToDoAppStates {}

class ToDoAppUpdateToDataBase extends ToDoAppStates {}

class ToDoAppDeleteDataFromDataBase extends ToDoAppStates {}
