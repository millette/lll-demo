// npm
import riot from "riot"

// self
import "./tags/riot-app.tag"
import "./tags/raw-html.tag"

import getCookie from "./cookie.js"

riot.mixin("getCookie", { getCookie })
riot.mount("riot-app")
