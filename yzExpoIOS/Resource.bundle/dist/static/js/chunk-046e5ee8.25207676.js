(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-046e5ee8"],{"06c5":function(t,n,e){"use strict";e.d(n,"a",(function(){return a}));e("a630"),e("fb6a"),e("b0c0"),e("d3b7"),e("25f0"),e("3ca3");var r=e("6b75");function a(t,n){if(t){if("string"===typeof t)return Object(r["a"])(t,n);var e=Object.prototype.toString.call(t).slice(8,-1);return"Object"===e&&t.constructor&&(e=t.constructor.name),"Map"===e||"Set"===e?Array.from(t):"Arguments"===e||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(e)?Object(r["a"])(t,n):void 0}}},"0a0b":function(t,n,e){"use strict";e.r(n);var r=function(){var t=this,n=t.$createElement,e=t._self._c||n;return e("van-row",{staticStyle:{height:"100%"}},[e("van-row",{staticClass:"dt-title",attrs:{type:"flex",align:"center"}},[e("van-col",{attrs:{span:"2"}},[e("van-icon",{staticClass:"dt-back",attrs:{name:"arrow-left"},on:{click:t.back}})],1),e("van-col",{attrs:{span:"20"}},[e("p",{staticClass:"dt-home-shouye"},[t._v("任务审核")])])],1),e("van-row",{staticClass:"dt-content"},[e("van-row",{staticClass:"dt-table"},[e("van-row",{staticClass:"dt-top"},[e("van-col",{staticClass:"dt-item-title",attrs:{span:8}},[t._v("任务编号：")]),e("span",{staticClass:"dt-item-content"},[t._v(t._s(t.order.TaskCode))])],1),e("van-row",{staticClass:"dt-top"},[e("van-col",{staticClass:"dt-item-title",attrs:{span:8}},[t._v("任务标题：")]),e("span",{staticClass:"dt-item-content"},[t._v(t._s(t.order.TaskTitle))])],1),e("van-row",{staticClass:"dt-top"},[e("van-col",{staticClass:"dt-item-title",attrs:{span:8}},[t._v("任务内容：")]),e("span",{staticClass:"dt-item-content"},[t._v(t._s(t.order.TaskContent))])],1),e("van-row",{staticClass:"dt-top"},[e("van-col",{staticClass:"dt-item-title",attrs:{span:8}},[t._v("任务状态：")]),e("span",{staticClass:"dt-item-content"},[t._v(t._s(t._f("filteOrderTStatus")(t.order.TaskStatus)))])],1),e("van-row",{staticClass:"dt-top"},[e("van-col",{staticClass:"dt-item-title",attrs:{span:8}},[t._v("提交人：")]),e("span",{staticClass:"dt-item-content"},[t._v(t._s(t.order.SubmitUserName))])],1),e("van-row",{staticClass:"dt-top"},[e("van-col",{staticClass:"dt-item-title",attrs:{span:8}},[t._v("提交时间：")]),e("span",{staticClass:"dt-item-content"},[t._v(t._s(t._f("filteDate")(t.order.SubmitTime)))])],1)],1),e("van-row",{staticClass:"dt-button-box"},[e("div",{staticClass:"dt-line"}),e("van-row",[e("van-col",{staticClass:"dt-button",attrs:{span:12}},[e("van-button",{staticStyle:{width:"100px"},attrs:{round:"",type:"info"},on:{click:t.reject}},[t._v("不通过")])],1),e("van-col",{staticClass:"dt-button",attrs:{span:12}},[e("van-button",{staticStyle:{width:"100px"},attrs:{round:"",type:"info"},on:{click:t.submit}},[t._v("通过")])],1)],1)],1)],1)],1)},a=[],o=(e("99af"),e("ac1f"),e("5319"),e("3835")),i=e("32c7"),s={components:{},data:function(){return{imgSrc:e("777a"),order:{},redeployShow:!1,redeployValue:"",rejectShow:!1,rejectValue:""}},filters:{filteDate:function(t){if(t)return t.replace("T"," ")},filteOrderTStatus:function(t){var n={1:"待审核",2:"已审核",3:"已驳回",4:"已完成"};return n[t]}},computed:{},watch:{},created:function(){},mounted:function(){this.getTestList()},beforeCreate:function(){},beforeMount:function(){},beforeUpdate:function(){},updated:function(){},beforeDestroy:function(){},destroyed:function(){},activated:function(){},methods:{getTestList:function(){var t=this;Object(i["a"])({ID:this.$route.query.ID}).then((function(n){n.Data.ContentList?t.order=n.Data.ContentList[0]:t.order=[]}))},formatDate:function(t){return"".concat(t.getMonth()+1,"/").concat(t.getDate())},onConfirm:function(t){var n=Object(o["a"])(t,2),e=n[0],r=n[1];this.show=!1,this.date="".concat(this.formatDate(e)," - ").concat(this.formatDate(r))},reject:function(){var t=this;this.$dialog.confirm({message:"确定驳回？"}).then((function(){t.order.TaskStatus=3,Object(i["d"])(t.order).then((function(n){t.$router.push({name:"MTTask"})}))})).catch((function(){}))},submit:function(){var t=this;this.$dialog.confirm({message:"确定通过？"}).then((function(){t.order.TaskStatus=2,Object(i["d"])(t.order).then((function(n){1===t.$route.query.modelType?t.$router.push({name:"MTTask"}):2===t.$route.query.modelType&&t.$router.push({name:"TMTask"})}))}))},back:function(){this.$store.commit("active",0),history.back(-1)}}},c=s,u=(e("a2f4"),e("2877")),f=Object(u["a"])(c,r,a,!1,null,"306a4f22",null);n["default"]=f.exports},3835:function(t,n,e){"use strict";function r(t){if(Array.isArray(t))return t}e.d(n,"a",(function(){return s}));e("a4d3"),e("e01a"),e("d28b"),e("d3b7"),e("3ca3"),e("ddb0");function a(t,n){if("undefined"!==typeof Symbol&&Symbol.iterator in Object(t)){var e=[],r=!0,a=!1,o=void 0;try{for(var i,s=t[Symbol.iterator]();!(r=(i=s.next()).done);r=!0)if(e.push(i.value),n&&e.length===n)break}catch(c){a=!0,o=c}finally{try{r||null==s["return"]||s["return"]()}finally{if(a)throw o}}return e}}var o=e("06c5");function i(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}function s(t,n){return r(t)||a(t,n)||Object(o["a"])(t,n)||i()}},"3ca3":function(t,n,e){"use strict";var r=e("6547").charAt,a=e("69f3"),o=e("7dd0"),i="String Iterator",s=a.set,c=a.getterFor(i);o(String,"String",(function(t){s(this,{type:i,string:String(t),index:0})}),(function(){var t,n=c(this),e=n.string,a=n.index;return a>=e.length?{value:void 0,done:!0}:(t=r(e,a),n.index+=t.length,{value:t,done:!1})}))},"4df4":function(t,n,e){"use strict";var r=e("0366"),a=e("7b0b"),o=e("9bdd"),i=e("e95a"),s=e("50c4"),c=e("8418"),u=e("35a1");t.exports=function(t){var n,e,f,l,d,v,p=a(t),b="function"==typeof this?this:Array,h=arguments.length,m=h>1?arguments[1]:void 0,y=void 0!==m,g=u(p),w=0;if(y&&(m=r(m,h>2?arguments[2]:void 0,2)),void 0==g||b==Array&&i(g))for(n=s(p.length),e=new b(n);n>w;w++)v=y?m(p[w],w):p[w],c(e,w,v);else for(l=g.call(p),d=l.next,e=new b;!(f=d.call(l)).done;w++)v=y?o(l,m,[f.value,w],!0):f.value,c(e,w,v);return e.length=w,e}},"6b75":function(t,n,e){"use strict";function r(t,n){(null==n||n>t.length)&&(n=t.length);for(var e=0,r=new Array(n);e<n;e++)r[e]=t[e];return r}e.d(n,"a",(function(){return r}))},"6b82":function(t,n,e){},"777a":function(t,n,e){t.exports=e.p+"static/img/工单背景.de869ed3.png"},"99af":function(t,n,e){"use strict";var r=e("23e7"),a=e("d039"),o=e("e8b5"),i=e("861d"),s=e("7b0b"),c=e("50c4"),u=e("8418"),f=e("65f0"),l=e("1dde"),d=e("b622"),v=e("2d00"),p=d("isConcatSpreadable"),b=9007199254740991,h="Maximum allowed index exceeded",m=v>=51||!a((function(){var t=[];return t[p]=!1,t.concat()[0]!==t})),y=l("concat"),g=function(t){if(!i(t))return!1;var n=t[p];return void 0!==n?!!n:o(t)},w=!m||!y;r({target:"Array",proto:!0,forced:w},{concat:function(t){var n,e,r,a,o,i=s(this),l=f(i,0),d=0;for(n=-1,r=arguments.length;n<r;n++)if(o=-1===n?i:arguments[n],g(o)){if(a=c(o.length),d+a>b)throw TypeError(h);for(e=0;e<a;e++,d++)e in o&&u(l,d,o[e])}else{if(d>=b)throw TypeError(h);u(l,d++,o)}return l.length=d,l}})},"9bdd":function(t,n,e){var r=e("825a"),a=e("2a62");t.exports=function(t,n,e,o){try{return o?n(r(e)[0],e[1]):n(e)}catch(i){throw a(t),i}}},a2f4:function(t,n,e){"use strict";e("6b82")},a630:function(t,n,e){var r=e("23e7"),a=e("4df4"),o=e("1c7e"),i=!o((function(t){Array.from(t)}));r({target:"Array",stat:!0,forced:i},{from:a})},b0c0:function(t,n,e){var r=e("83ab"),a=e("9bf2").f,o=Function.prototype,i=o.toString,s=/^\s*function ([^ (]*)/,c="name";r&&!(c in o)&&a(o,c,{configurable:!0,get:function(){try{return i.call(this).match(s)[1]}catch(t){return""}}})},d28b:function(t,n,e){var r=e("746f");r("iterator")},e01a:function(t,n,e){"use strict";var r=e("23e7"),a=e("83ab"),o=e("da84"),i=e("5135"),s=e("861d"),c=e("9bf2").f,u=e("e893"),f=o.Symbol;if(a&&"function"==typeof f&&(!("description"in f.prototype)||void 0!==f().description)){var l={},d=function(){var t=arguments.length<1||void 0===arguments[0]?void 0:String(arguments[0]),n=this instanceof d?new f(t):void 0===t?f():f(t);return""===t&&(l[n]=!0),n};u(d,f);var v=d.prototype=f.prototype;v.constructor=d;var p=v.toString,b="Symbol(test)"==String(f("test")),h=/^Symbol\((.*)\)[^)]+$/;c(v,"description",{configurable:!0,get:function(){var t=s(this)?this.valueOf():this,n=p.call(t);if(i(l,t))return"";var e=b?n.slice(7,-1):n.replace(h,"$1");return""===e?void 0:e}}),r({global:!0,forced:!0},{Symbol:d})}},fb6a:function(t,n,e){"use strict";var r=e("23e7"),a=e("861d"),o=e("e8b5"),i=e("23cb"),s=e("50c4"),c=e("fc6a"),u=e("8418"),f=e("b622"),l=e("1dde"),d=e("ae40"),v=l("slice"),p=d("slice",{ACCESSORS:!0,0:0,1:2}),b=f("species"),h=[].slice,m=Math.max;r({target:"Array",proto:!0,forced:!v||!p},{slice:function(t,n){var e,r,f,l=c(this),d=s(l.length),v=i(t,d),p=i(void 0===n?d:n,d);if(o(l)&&(e=l.constructor,"function"!=typeof e||e!==Array&&!o(e.prototype)?a(e)&&(e=e[b],null===e&&(e=void 0)):e=void 0,e===Array||void 0===e))return h.call(l,v,p);for(r=new(void 0===e?Array:e)(m(p-v,0)),f=0;v<p;v++,f++)v in l&&u(r,f,l[v]);return r.length=f,r}})}}]);
//# sourceMappingURL=chunk-046e5ee8.25207676.js.map