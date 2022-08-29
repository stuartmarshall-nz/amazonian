function calculateDaysBetweenDates(begin, end) {
    var oneDay = 24*60*60*1000; // hours*minutes*seconds*milliseconds
    var firstDate = new Date(begin);
    var secondDate = new Date(end);

    return Math.round(Math.abs((firstDate.getTime() - secondDate.getTime())/(oneDay)));
}

function calculateMax(num1, num2) {
    return Math.max(num1, num2);
}
}