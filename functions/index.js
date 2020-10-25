const functions = require("firebase-functions");

exports.cartadd = functions.database
  .ref("users/{user-id}/cart/{cart-id}")
  .onWrite((event) => {
    const snapshot = event.data;
    if (snapshot.hasChildren()) {
      var total = 0;
      snapshot.forEach(function (item) {
        total += item.child("price").val();
      });
      console.log(total);
    }
  });
