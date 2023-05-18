window.addEventListener('click', (event) => {
  if (event.target.classList == 'start-timer1') {
    startCountdown1();
  }
  if (event.target.classList == 'stop-timer1') {
    pauseCountdown1();
  }

  if (event.target.classList == 'start-timer2') {
    startCountdown2();
  }
  if (event.target.classList == 'stop-timer2') {
    pauseCountdown2();
  }
});

var countdownTimer1;
var countdownDate1;
var paused1 = false;
var remainingTime1;

function startCountdown1() {
  if (!remainingTime1) {
    if (!countdownDate1 || paused1) {
      if (!countdownDate1) {
        // Set the countdown date and time
        countdownDate1 = new Date();
        countdownDate1.setMinutes(countdownDate1.getMinutes() + 10);
        countdownDate1 = countdownDate1.getTime();
      }

      paused1 = false;

      var currentTime1 = new Date().getTime();
      remainingTime1 = countdownDate1 - currentTime1;
    }
  }
  countdownTimer1 = setInterval(function () {
    remainingTime1 -= 1000;

    if (remainingTime1 < 0) {
      clearInterval(countdownTimer1);
      document.getElementById('countdown1').innerHTML = 'Countdown has ended!';
      return;
    }

    var minutes = Math.floor((remainingTime1 % (1000 * 60 * 60)) / (1000 * 60));
    var seconds = Math.floor((remainingTime1 % (1000 * 60)) / 1000);

    var formattedTime =
      ('0' + minutes).slice(-2) + ':' + ('0' + seconds).slice(-2);
    document.getElementById('countdown1').innerHTML = formattedTime;
  }, 1000);
}

function pauseCountdown1() {
  clearInterval(countdownTimer1);
  paused1 = true;
}

var countdownTimer2;
var countdownDate2;
var paused2 = false;
var remainingTime2;

function startCountdown2() {
  if (!remainingTime2) {
    if (!countdownDate2 || paused2) {
      if (!countdownDate2) {
        // Set the countdown date and time
        countdownDate2 = new Date();
        countdownDate2.setMinutes(countdownDate2.getMinutes() + 10);
        countdownDate2 = countdownDate2.getTime();
      }

      paused2 = false;

      var currentTime2 = new Date().getTime();
      remainingTime2 = countdownDate2 - currentTime2;
    }
  }
  countdownTimer2 = setInterval(function () {
    remainingTime2 -= 1000;

    if (remainingTime2 < 0) {
      clearInterval(countdownTimer2);
      document.getElementById('countdown2').innerHTML = 'Countdown has ended!';
      return;
    }

    var minutes = Math.floor((remainingTime2 % (1000 * 60 * 60)) / (1000 * 60));
    var seconds = Math.floor((remainingTime2 % (1000 * 60)) / 1000);

    var formattedTime =
      ('0' + minutes).slice(-2) + ':' + ('0' + seconds).slice(-2);
    document.getElementById('countdown2').innerHTML = formattedTime;
  }, 1000);
}

function pauseCountdown2() {
  clearInterval(countdownTimer2);
  paused2 = true;
}

const something1 = () => {
  startCountdown1();
  pauseCountdown2();
}

const something2 = () => {
  startCountdown2()
}

document.addEventListener('DOMContentLoaded', something1);
document.addEventListener('DOMContentLoaded', something2);
