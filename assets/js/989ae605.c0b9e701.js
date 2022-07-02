"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[895],{3905:(e,r,n)=>{n.d(r,{Zo:()=>u,kt:()=>v});var t=n(67294);function a(e,r,n){return r in e?Object.defineProperty(e,r,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[r]=n,e}function o(e,r){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var t=Object.getOwnPropertySymbols(e);r&&(t=t.filter((function(r){return Object.getOwnPropertyDescriptor(e,r).enumerable}))),n.push.apply(n,t)}return n}function i(e){for(var r=1;r<arguments.length;r++){var n=null!=arguments[r]?arguments[r]:{};r%2?o(Object(n),!0).forEach((function(r){a(e,r,n[r])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(r){Object.defineProperty(e,r,Object.getOwnPropertyDescriptor(n,r))}))}return e}function l(e,r){if(null==e)return{};var n,t,a=function(e,r){if(null==e)return{};var n,t,a={},o=Object.keys(e);for(t=0;t<o.length;t++)n=o[t],r.indexOf(n)>=0||(a[n]=e[n]);return a}(e,r);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(t=0;t<o.length;t++)n=o[t],r.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var s=t.createContext({}),c=function(e){var r=t.useContext(s),n=r;return e&&(n="function"==typeof e?e(r):i(i({},r),e)),n},u=function(e){var r=c(e.components);return t.createElement(s.Provider,{value:r},e.children)},m={inlineCode:"code",wrapper:function(e){var r=e.children;return t.createElement(t.Fragment,{},r)}},d=t.forwardRef((function(e,r){var n=e.components,a=e.mdxType,o=e.originalType,s=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),d=c(n),v=a,p=d["".concat(s,".").concat(v)]||d[v]||m[v]||o;return n?t.createElement(p,i(i({ref:r},u),{},{components:n})):t.createElement(p,i({ref:r},u))}));function v(e,r){var n=arguments,a=r&&r.mdxType;if("string"==typeof e||a){var o=n.length,i=new Array(o);i[0]=d;var l={};for(var s in r)hasOwnProperty.call(r,s)&&(l[s]=r[s]);l.originalType=e,l.mdxType="string"==typeof e?e:a,i[1]=l;for(var c=2;c<o;c++)i[c]=n[c];return t.createElement.apply(null,i)}return t.createElement.apply(null,n)}d.displayName="MDXCreateElement"},39820:(e,r,n)=>{n.r(r),n.d(r,{assets:()=>s,contentTitle:()=>i,default:()=>m,frontMatter:()=>o,metadata:()=>l,toc:()=>c});var t=n(87462),a=(n(67294),n(3905));const o={sidebar_position:7},i="Services",l={unversionedId:"services",id:"services",title:"Services",description:"Services are tables that expose a public API for Providers. Services allow for you to keep providers self contained and secure. Why do we need Services? Lets take a look at an example:",source:"@site/docs/services.md",sourceDirName:".",slug:"/services",permalink:"/glue/docs/services",draft:!1,editUrl:"https://github.com/afrxo/glue/edit/master/docs/services.md",tags:[],version:"current",sidebarPosition:7,frontMatter:{sidebar_position:7},sidebar:"defaultSidebar",previous:{title:"Networking",permalink:"/glue/docs/networking"},next:{title:"Bindings",permalink:"/glue/docs/bindings"}},s={},c=[{value:"Security",id:"security",level:2},{value:"Abstraction",id:"abstraction",level:2},{value:"Full Example",id:"full-example",level:2}],u={toc:c};function m(e){let{components:r,...n}=e;return(0,a.kt)("wrapper",(0,t.Z)({},u,n,{components:r,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"services"},"Services"),(0,a.kt)("p",null,"Services are tables that expose a public API for Providers. Services allow for you to keep providers self contained and secure. Why do we need Services? Lets take a look at an example:"),(0,a.kt)("p",null,"Here we have a Provider that creates a table of names on ",(0,a.kt)("inlineCode",{parentName:"p"},"onCreate")," and has a getter method that returns a direct reference to those names."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'local NameProvider = { Name = "NameProvider" }\n\nfunction NameProvider:onCreate()\n    self.Names = {"Foo", "Bar", "Baz"}\nend\n\nfunction NameProvider:CountNames()\n    print("There are " .. #self:GetNames() .. " names")\nend\n\nfunction NameProvider:GetNames()\n    return self.Names\nend\n\nGlue.Provider(NameProvider)\n')),(0,a.kt)("p",null,"How do we gain access to those names outside of the NameProvider? Well, here's two ways you could."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'Glue.Stick():andThen(function()\n    local NameProvider = Glue.GetProvider("NameProvider")\n    local Names = NameProvider.Names\nend)\n')),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'Glue.Stick():andThen(function()\n    local NameProvider = Glue.GetProvider("NameProvider")\n    local Names = NameProvider:GetNames()\nend)\n')),(0,a.kt)("h2",{id:"security"},"Security"),(0,a.kt)("p",null,"Though both of these method acquire the Names accordingly, they aren't as secure since we now have a direct reference to the Names state, which means we can actively makes changes to it, that will be replicated everywhere else the Names state is being used. "),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'Glue.Stick():andThen(function()\n    local NameProvider = Glue.GetProvider("NameProvider")\n    local Names = NameProvider:GetNames()\n    Names[4] = "Qux"\n    print(Names, NameProvider:GetNames())\nend)\n')),(0,a.kt)("p",null,"I suppose we could have the ",(0,a.kt)("inlineCode",{parentName:"p"},"GetNames")," return a table.copy of the Names state like so:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'local NameProvider = { Name = "NameProvider" }\n\nfunction NameProvider:onCreate()\n    self.Names = {"Foo", "Bar", "Baz"}\nend\n\nfunction NameProvider:GetNames()\n    return table.copy(self.Names)\nend\n\nGlue.Provider(NameProvider)\n')),(0,a.kt)("p",null,"Though this means that the method is rendered completely useless for internal usage, because it doesnt return a direct reference to the Names state. Well how can we make the Names state secure for Internal and Public usage? This is where Services come in handy. Here's how you do it:"),(0,a.kt)("h2",{id:"abstraction"},"Abstraction"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'local NameServiceProvider = { Name = "NameProvider" }\n\nfunction NameServiceProvider:onCreate()\n    self.Names = {"Foo", "Bar", "Baz"}\nend\n\nfunction NameServiceProvider:GetNames()\n    return self.Names\nend\n\nlocal NameService = {}\n\nfunction NameService:GetNames()\n    return table.clone(NameServiceProvider:GetNames())\nend\n\nNameServiceProvider.Service = NameService\nGlue.Provider("NameProvider", NameServiceProvider)\n')),(0,a.kt)("p",null,"Pretty simple, right? The service definition is just a table of methods or properties ready for public usage, completely isolating the Provider itself."),(0,a.kt)("h2",{id:"full-example"},"Full Example"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'local Glue = require(game.ReplicatedStorage.Bundle.Glue)\n\nlocal NameServiceProvider = Glue.Provider("NameProvider")\n\nfunction NameServiceProvider:onCreate()\n    self.Names = {"Foo", "Bar", "Baz"}\nend\n\nfunction NameServiceProvider:CountNames()\n    print("There are " .. #self:GetNames() .. " names.")\nend\n\nfunction NameServiceProvider:GetNames()\n    return self.Names\nend\n\nlocal NameService = {}\n\nfunction NameService:GetNames()\n    return table.clone(NameServiceProvider:GetNames())\nend\n\nfunction NameService:CountNames()\n    NameServiceProvider:CountNames()\nend\n\nNameServiceProvider.Service = NameService\n\nGlue.Stick():andThen(function()\n    local BuiltNameProvider = Glue.GetProvider("NameProvider")\n    local Names = BuiltNameProvider:GetNames()\n    NameService:CountNames()\n    Names[4] = "Quz"\n    NameService:CountNames()    \nend)\n')))}m.isMDXComponent=!0}}]);