
// TODO: Optimize and only import what is needed
import Chart from 'chart.js/auto' // OPTIMIZE: Don't import everything?

function scale(input, inputMin, outputMin, inputMax, outputMax) {
  var scaledInput = (input - inputMin) / (inputMax - inputMin);
  var scaledOutput = scaledInput * (outputMax - outputMin) + outputMin;
  var min = Math.min(outputMin, outputMax)
  var max = Math.max(outputMin, outputMax)

  if (scaledOutput > max) {
    return max
  } else if (scaledOutput < min) {
    return min
  }
  return scaledOutput;
}

document.addEventListener("DOMContentLoaded", function() {

  document.getElementById('runSimulBtn').addEventListener('click', () => {

    let p = parseFloat(document.getElementById('p').value)
    let i = parseFloat(document.getElementById('i').value)
    let dead = parseFloat(document.getElementById('dead').value)
    let reset = parseFloat(document.getElementById('reset').value)
    let bias = parseFloat(document.getElementById('bias').value)
    let variation = parseFloat(document.getElementById('variation').value)
    let variation_cool = parseFloat(document.getElementById('variation_cool').value)
    let variation_heat = parseFloat(document.getElementById('variation_heat').value)
    let interval = parseFloat(document.getElementById('interval').value)
    let input = parseFloat(document.getElementById('input').value)
    let pc = parseFloat(document.getElementById('pc').value)
    let nb_pt = parseFloat(document.getElementById('nb_pt').value)
    let interval_calcul = parseFloat(document.getElementById('interval_calcul').value)
    let k = interval_calcul / interval

    const pvs = []
    const outs = []
    console.log(nb_pt)
    let pv = input
    let out = bias
    for (let i = 0; i < nb_pt; i++) {
      pv += variation*k + variation_cool*k*scale(out, 50, 0, 100, 1) + variation_heat*k*scale(out, 0, 1, 50, 0)
      pvs.push(pv)
      if (Math.abs(pv-pc)<dead/2) {
        out = bias
      }
      if (pv < pc - dead/2) {
        out = 0
      } else if (pv > pc + dead/2) {
        out = 100
      }
      outs.push(out)
    }
  
    new Chart(
      document.getElementById('graph'),
      {
        type: 'line',
        data: {
          labels: pvs.map((e,i) => (interval_calcul*i).toFixed(2)),
          datasets: [
            {
              label: 'Entrée',
              data: pvs,
              pointStyle: false,
            },
            {
              label: 'Consigne',
              data: pvs.map(i => pc),
              pointStyle: false,
            },
          ]
        }
      }
    );

    new Chart(
      document.getElementById('graph-output'),
      {
        type: 'line',
        data: {
          labels: outs.map((e,i) => (interval_calcul*i).toFixed(2)),
          datasets: [
            {
              label: 'Output',
              data: outs,
              pointStyle: false,
            },
            {
              label: 'Cooling',
              data: outs.map(out => scale(out, 50, 0, 100, 100)),
              pointStyle: false,
            },
            {
              label: 'Heating',
              data: outs.map(out => scale(out, 0, 100, 50, 0)),
              pointStyle: false,
            }
          ]
        }
      }
    );


  }, false)

});