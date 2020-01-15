Fetch and cancel theeye api jobs

https://documentation.theeye.io/api/jobs

sample usage in recipes

```javascript
  
  // cancel pending jobs

const jobsApi = require('./jobs)
let customerName = JSON.parse( process.env.THEEYE_ORGANIZATION_NAME ) // this is JSON string
let jobName = ''

//let ACCESS_TOKEN = process.env.ACCESS_TOKEN

const main = async () => {
  try {
    // fetch pending jobs. lifecycle: ready
    const resp = await jobsApi.fetch(customerName, { name: jobName, lifecycle: 'ready' })

    let jobs = JSON.parse(resp);
    console.log(data.length)

    //  for..of allow async/await calls
    for (let job of jobs) {
      await jobsApi.cancel(customerName, job)
    }
  }
}

main ()
```
