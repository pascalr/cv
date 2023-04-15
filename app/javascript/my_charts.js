
// TODO: Optimize and only import what is needed
import Chart from 'chart.js/auto' // OPTIMIZE: Don't import everything?
import * as Utils from 'chart.js/helpers';

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

    const pvs = []
    const outs = []
    console.log(nb_pt)
    for (let i = 0; i < nb_pt; i++) {
      const temps = interval_calcul * i
      const nb_variation = Math.floor(temps / interval)
      const pv = input+(nb_variation*variation)
      pvs.push(pv)
      const out = bias
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
            }
          ]
        }
      }
    );


  }, false)

});