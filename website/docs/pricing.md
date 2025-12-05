# Pricing

This project is creating free and open-source software under the MIT license.
There are plenty of ways to run the workflow locally after downloading the [data](background.html#data).
However, the workflow can also be executed using [openEO at EODC](https://editor.openeo.org/?server=openeo.eodc.eu%2Fopeneo%2F1.2.0%2F) by enabling experimental processes and searching for 'rqadeforestation'.

## Price calculator

Please enter the spatio-temporal extent to be processed.
The price will be estimated automatically.
Resource estimations were based on the following assumptions:

- Sentinel-1 Sigma0 collection at 20m resolution in Equi7 projection
- Tile size is 15000x15000 pixels
- Satellite revisit period of 6 days
- Data is available in GeoTIFF format
- Files are located on a network share in the same data center
- Execution on an AMD EPIC MILAN CPU on 32 threads with 32GB RAM
- 100% utilization of CPU and RAM (4 workers with 8 threads each)
- Workflow is executed inside a Julia REPL using [RQADeforestation.jl](https://github.com/EarthyScience/RQADeforestation.jl)
 
 <script setup>
  import { ref, computed, onMounted, watch } from 'vue'
  const start = ref('')
  const end = ref('')
  const n_tiles = ref(1)
  const submitted = ref(false)
  const error = ref('')
  let runtime = 0
  const valid = computed(() => {
    if (!start.value || !end.value) return false
    if (start.value > end.value) return false
    if (!Number.isInteger(n_tiles.value) || n_tiles.value < 0) return false
    return true
  })
  watch([start, end, n_tiles], () => {
    error.value = ""
    if (start.value && end.value && start.value > end.value) {
      error.value = "Start date must be on or before end date."
    }
    if (Date.parse(start.value) < Date.parse("2014-10-01")) {
      error.value = "Data only available after Oct 2014"
    }
    if (!Number.isInteger(n_tiles.value)) {
      error.value = "Count must be an integer."
    }
  const runtime_per_year_per_tile_in_s = 384.673805
  const satellite_revisit_days = 6
  let duration_years = (Date.parse(end.value) - Date.parse(start.value)) * 1e-3 / 60 / 60 / 24 / 365
  runtime = n_tiles.value * (duration_years*runtime_per_year_per_tile_in_s)^2
  })
  onMounted(() => {
    start.value = "2022-01-01"
    end.value = "2023-01-01"
  })
</script> 

<form @submit.prevent="onSubmit" class="form-horizontal">
  <div class="form-floating">
    <label for="start">Start date</label><br />
    <input id="start" type="date" v-model="start" class="form-control" required />
  </div>

  <div class="form-floating">
    <label for="end">End date</label><br />
    <input id="end" type="date" v-model="end" :min="start" class="form-control" required />
  </div>

  <div class="form-floating">
    <label for="n_tiles">Number of Equi7 tiles</label><br />
    <input
      id="n_tiles"
      type="number"
      v-model.number="n_tiles"
      min="1"
      step="1"
      inputmode="numeric"
      class="form-control"
      required
    />
  </div>

  <div v-if="error" style="color:#b00020;margin-top:0.4rem">{{ error }}</div>

  <strong>Estimated runtime: {{ runtime }} s</strong>
</form>

Please note that these results are not official offerings from any cloud provider.
Estimates may vary depending on the area of interest, orbits to be analysed, and execution platform.