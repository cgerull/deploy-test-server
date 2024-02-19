import { parseHTML } from 'k6/html';
import { check,sleep } from 'k6';
import http from 'k6/http';
import chai, { describe, expect } from 'https://jslib.k6.io/k6chaijs/4.3.4.3/index.js';

export const options = {
  // iterations: 3,
  // Key configurations for avg load test in this section
  stages: [
    { duration: '5m', target: 100 }, // traffic ramp-up from 1 to 100 users over 5 minutes.
    { duration: '30m', target: 100 }, // stay at 100 users for 30 minutes
    { duration: '5m', target: 0 }, // ramp-down to 0 users
  ],

};

export default function () {
  const res = http.get('http://pi4bnode01:4080/echo');
  const doc = parseHTML(res.body); // equivalent to res.html()
  const pageTitle = doc.find('head title').text();
  const langAttr = doc.find('html').attr('lang');

  check(res, {
    'response code was 200': (res) => res.status == 200,
  });
  sleep(1);
  // expect(res.status, "Auth status").to.be.within(200, 204)
}
