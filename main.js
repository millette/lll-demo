// taken from https://bl.ocks.org/mbostock/1095795

// npm
import { deburr, uniq } from "lodash-es"
import riot from "riot"

// self
import "./tags/index.js"

/*
riot.mixin({
  fetchFollows,
  fetchOne,
  clearGraph,
  deburr,
  uniq,
})
*/

const elApp = riot.mount("app")[0]
