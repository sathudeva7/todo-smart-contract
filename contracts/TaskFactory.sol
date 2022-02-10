// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract TaskFactory {
	event NewTask(uint taskId, string task, bool completed, bool approved, uint reward);

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

	function _createTask(string memory _task, bool _completed, bool _approved, uint _reward) external payable {
		tasks.push(Task(_task, _completed, _approved, _reward));
        uint id = tasks.length - 1;
		taskToOwner[id] = msg.sender;
		ownerTaskCount[msg.sender]++;
	//	depositUsingParameter(_reward);
		emit NewTask(id, _task, _completed, _approved, _reward);
	}

	function depositUsingParameter(uint256 deposit) public payable {  
        require(msg.value == deposit);
        deposit = msg.value;
    }

	function _viewTasks() public view returns (Task[] memory) {
		return tasks;
	}

	function _addChild(address _childId, uint _taskId) public payable{
		childToTask[_taskId] = _childId;
	}

	function _updateCompleteTask(uint _taskId) public payable {
		require(msg.sender == childToTask[_taskId]);
		tasks[_taskId].completed = true;	
	}	

	function _updateApproveTask(uint _taskId) external payable {
		require(msg.sender == taskToOwner[_taskId]);
		tasks[_taskId].approved = true;

		payable(childToTask[_taskId]).transfer((tasks[_taskId].reward)* 1 ether);
	}

	function _withdraw(uint _taskId) external payable {
		require(msg.sender == taskToOwner[_taskId]);
		require(tasks[_taskId].approved == false);
		payable(msg.sender).transfer(tasks[_taskId].reward);
	}

}
		
		  