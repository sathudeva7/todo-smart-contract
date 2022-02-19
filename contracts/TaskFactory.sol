// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract TaskFactory {

	struct Task {
		string task;
		bool completed;
		bool approved;
		uint reward;
	}

	Task[] public tasks;

	mapping (uint => address) public taskToOwner;
	mapping (address => uint) ownerTaskCount;
	mapping (uint => address) public childToTask;

	event NewTask(uint taskId, string task, bool completed, bool approved, uint reward);

	event TaskCompleted(uint taskId, string message);


	function _createTask(string memory _task, bool _completed, bool _approved) external payable {
		tasks.push(Task(_task, _completed, _approved, msg.value));
        uint id = tasks.length - 1;
		taskToOwner[id] = msg.sender;
		ownerTaskCount[msg.sender]++;
		emit NewTask(id, _task, _completed, _approved, msg.value);
	}

	function _viewTasks() public view returns (Task[] memory) {
		return tasks;
	}

	function _getBalance() public view returns (uint balance) {
		return address(this).balance;
	}

	function _addChild(address _childId, uint _taskId) public payable returns (bool isChildAdded, string memory childAddedStatus){
			require(childToTask[_taskId] == address(0),"Task already has a child");
			require(msg.sender == taskToOwner[_taskId], "Task owner can only add child");
			childToTask[_taskId] = _childId;
			return (true, "Child Added Successfully");
	}

	function _updateCompleteTask(uint _taskId) public payable {
		require(msg.sender == childToTask[_taskId], "Task not assigned to this address");
		tasks[_taskId].completed = true;	
		emit TaskCompleted(_taskId, "Task Completed");
	}	

	function _updateApproveTask(uint _taskId) external payable returns (bool isApproved, string memory approvedStatus){
		require(msg.sender == taskToOwner[_taskId], "Task owner can only approve");
		tasks[_taskId].approved = true;
		(bool success, ) = payable(childToTask[_taskId]).call{value:tasks[_taskId].reward}("Reward sent to child");
		require(success, "call failed");
		return (true, "Task Approved successfully") ;
	}

	function _withdraw(uint _taskId) external payable returns (bool isWithdraw, string memory withrawStatus){
		require(msg.sender == taskToOwner[_taskId], "Task owner can only withdraw");
		require(tasks[_taskId].approved == false, "Task already approved");
		(bool success, ) = (msg.sender).call{value:tasks[_taskId].reward}("Reward withdraw to parent");
		tasks[_taskId].approved = true;
		require(success, "call failed");
		return (true, "Reward withdrawed");
	}

}
		
		  