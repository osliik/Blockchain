// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract AIMarketplace {
    struct Model {
        string name;
        string description;
        uint256 price;
        address payable creator;
        uint8 ratingCount;
        uint256 totalRating;
    }

    Model[] private models;  // Changed public to private for encapsulation
    address private owner;    // Changed public to private for encapsulation

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
    }

    // Function to list a new model
    function listModel(
        string memory name,
        string memory description,
        uint256 price
    ) public {
        models.push(Model({
            name: name,
            description: description,
            price: price,
            creator: payable(msg.sender),
            ratingCount: 0,
            totalRating: 0
        }));
    }

    // Function to purchase a model
    function purchaseModel(uint256 modelId) public payable {
        require(modelId < models.length, "Model does not exist");
        require(msg.value == models[modelId].price, "Incorrect value sent");

        models[modelId].creator.transfer(msg.value);
    }

    // Function to rate a model
    function rateModel(uint256 modelId, uint8 rating) public {
        require(modelId < models.length, "Model does not exist");
        require(rating >= 1 && rating <= 5, "Rating must be between 1 and 5");

        models[modelId].ratingCount++;
        models[modelId].totalRating += rating;
    }

    // Function to delete a model
    function deleteModel(uint256 modelId) public {
        require(modelId < models.length, "Model does not exist");

        Model memory model = models[modelId];
        require(msg.sender == model.creator || msg.sender == owner, "Only the creator or owner can delete the model");

        // Replace the model to be deleted with the last model in the array
        models[modelId] = models[models.length - 1];
        models.pop();  // Remove the last model (now a duplicate)
    }

    // Function for the owner to withdraw funds
    function withdrawFunds() public {
        require(msg.sender == owner, "Only owner can withdraw funds");
        payable(msg.sender).transfer(address(this).balance);
    }

    // Function to get model details
    function getModelDetails(uint256 modelId) public view returns (
        string memory,
        string memory,
        uint256,
        address,
        uint8,
        uint256
    ) {
        require(modelId < models.length, "Model does not exist");
        Model memory model = models[modelId];
        return (model.name, model.description, model.price, model.creator, model.ratingCount, model.totalRating);
    }

    // Function to get the count of models
    function modelCount() public view returns (uint256) {
        return models.length;
    }
}
