// npm
import riot from "riot"

// self
import "./tags/index.js"
import getCookie from "./cookie.js"

riot.mixin("getCookie", { getCookie })
riot.mount("riot-app")
