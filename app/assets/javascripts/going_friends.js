function toggleDiv() {
    setTimeout(function () {
        $(".num_friends_link").show();
        setTimeout(function () {
            $(".num_friends_link").hide();
            toggleDiv();
        }, 3000);
    }, 3000);
}
toggleDiv();  