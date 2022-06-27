"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[374,514,938],{3905:function(e,t,n){n.d(t,{Zo:function(){return u},kt:function(){return d}});var r=n(67294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function c(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var i=r.createContext({}),s=function(e){var t=r.useContext(i),n=t;return e&&(n="function"==typeof e?e(t):c(c({},t),e)),n},u=function(e){var t=s(e.components);return r.createElement(i.Provider,{value:t},e.children)},m={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},p=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,o=e.originalType,i=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),p=s(n),d=a,f=p["".concat(i,".").concat(d)]||p[d]||m[d]||o;return n?r.createElement(f,c(c({ref:t},u),{},{components:n})):r.createElement(f,c({ref:t},u))}));function d(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=n.length,c=new Array(o);c[0]=p;var l={};for(var i in t)hasOwnProperty.call(t,i)&&(l[i]=t[i]);l.originalType=e,l.mdxType="string"==typeof e?e:a,c[1]=l;for(var s=2;s<o;s++)c[s]=n[s];return r.createElement.apply(null,c)}return r.createElement.apply(null,n)}p.displayName="MDXCreateElement"},4167:function(e,t,n){n.r(t),n.d(t,{HomepageFeatures:function(){return E},default:function(){return k}});var r=n(87462),a=n(63366),o=n(67294),c=n(3905),l=["components"],i={toc:[{value:"Powered by Promise, Luau",id:"powered-by-promise-luau",children:[],level:6}]};function s(e){var t=e.components,n=(0,a.Z)(e,l);return(0,c.kt)("wrapper",(0,r.Z)({},i,n,{components:t,mdxType:"MDXLayout"}),(0,c.kt)("p",null,(0,c.kt)("a",{parentName:"p",href:"https://github.com/afrxo/glue/actions/workflows/docs.yml"},(0,c.kt)("img",{parentName:"a",src:"https://github.com/afrxo/glue/actions/workflows/docs.yml/badge.svg",alt:"Deploy Docs"}))),(0,c.kt)("p",null,"Glue is an opinionated game framework for Roblox that assists you in writing cleaner netcode and streamlines interaction between fundamental mechanics of your game. The impulse behind Glue is to give the developer as much flexiblity and configuration as possible, leaving the way the developer writes their code up to them and sets up the nifty parts."),(0,c.kt)("p",null,"Read the full documentation ",(0,c.kt)("a",{parentName:"p",href:"https://afrxo.github.io/glue"},"here"),"."),(0,c.kt)("h6",{id:"powered-by-promise-luau"},"Powered by ",(0,c.kt)("a",{parentName:"h6",href:"https://eryn.io/roblox-lua-promise/"},"Promise"),", ",(0,c.kt)("a",{parentName:"h6",href:"https://luau-lang.org/"},"Luau")))}s.isMDXComponent=!0;var u=n(39960),m=n(52263),p=n(54814),d=n(86010),f="heroBanner_PAbV",h="buttons_2tNn",b="features_3cQC",y="featureSvg_1mXg",v=[{title:"Rich API",description:"The Glue API consists of various modules and functions that assist the developer in writing less code and focus on whats important. Glue API will always add more functionality to your code, rather than regressing it."}];function g(e){var t=e.image,n=e.title,r=e.description;return o.createElement("div",{className:(0,d.Z)("col col--4")},t&&o.createElement("div",{className:"text--center"},o.createElement("img",{className:y,alt:n,src:t})),o.createElement("div",{className:"text--center padding-horiz--md"},o.createElement("h3",null,n),o.createElement("p",null,r)))}function E(){return v?o.createElement("section",{className:b},o.createElement("div",{className:"container"},o.createElement("div",{className:"row"},v.map((function(e,t){return o.createElement(g,(0,r.Z)({key:t},e))}))))):null}function w(){var e=(0,m.Z)().siteConfig;return o.createElement("header",{className:(0,d.Z)("hero",f)},o.createElement("div",{className:"container"},o.createElement("h1",{className:"hero__title"},e.title),o.createElement("p",{className:"hero__subtitle"},e.tagline),o.createElement("div",{className:h},o.createElement(u.Z,{className:"button button--secondary button--lg",to:"/docs/intro"},"Get Started \u2192"))))}function k(){var e=(0,m.Z)(),t=e.siteConfig,n=e.tagline;return o.createElement(p.Z,{title:t.title,description:n},o.createElement(w,null),o.createElement("main",null,o.createElement(E,null),o.createElement("div",{className:"container"},o.createElement(s,null))))}},6979:function(e,t,n){var r=n(76775),a=n(52263),o=n(28084),c=n(94184),l=n.n(c),i=n(67294);t.Z=function(e){var t=(0,i.useRef)(!1),c=(0,i.useRef)(null),s=(0,r.k6)(),u=(0,a.Z)().siteConfig,m=(void 0===u?{}:u).baseUrl;(0,i.useEffect)((function(){var e=function(e){"s"!==e.key&&"/"!==e.key||c.current&&e.srcElement===document.body&&(e.preventDefault(),c.current.focus())};return document.addEventListener("keydown",e),function(){document.removeEventListener("keydown",e)}}),[]);var p=(0,o.usePluginData)("docusaurus-lunr-search"),d=function(){t.current||(Promise.all([fetch(""+m+p.fileNames.searchDoc).then((function(e){return e.json()})),fetch(""+m+p.fileNames.lunrIndex).then((function(e){return e.json()})),Promise.all([n.e(878),n.e(245)]).then(n.bind(n,24130)),Promise.all([n.e(532),n.e(343)]).then(n.bind(n,53343))]).then((function(e){var t=e[0],n=e[1],r=e[2].default;0!==t.length&&function(e,t,n){new n({searchDocs:e,searchIndex:t,inputSelector:"#search_input_react",handleSelected:function(e,t,n){var r=m+n.url;document.createElement("a").href=r,s.push(r)}})}(t,n,r)})),t.current=!0)},f=(0,i.useCallback)((function(t){c.current.contains(t.target)||c.current.focus(),e.handleSearchBarToggle&&e.handleSearchBarToggle(!e.isSearchBarExpanded)}),[e.isSearchBarExpanded]);return i.createElement("div",{className:"navbar__search",key:"search-box"},i.createElement("span",{"aria-label":"expand searchbar",role:"button",className:l()("search-icon",{"search-icon-hidden":e.isSearchBarExpanded}),onClick:f,onKeyDown:f,tabIndex:0}),i.createElement("input",{id:"search_input_react",type:"search",placeholder:"Press S to Search...","aria-label":"Search",className:l()("navbar__search-input",{"search-bar-expanded":e.isSearchBarExpanded},{"search-bar":!e.isSearchBarExpanded}),onClick:d,onMouseOver:d,onFocus:f,onBlur:f,ref:c}))}}}]);