(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-7c0de8e0"],{"0834":function(t,e,n){"use strict";n("17c7")},"17c7":function(t,e,n){},"5d41":function(t,e,n){"use strict";var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{class:t.sizeClass},[t._v(t._s(t._f("filtName")(t.username)))])},o=[],r=(n("fb6a"),{components:{},props:["username","size"],filters:{filtName:function(t){return t?t.length>2?t.slice(t.length-2,t.length):t:"员工"}},data:function(){return{sizeClass:""}},computed:{},watch:{},created:function(){"large"==this.size?this.sizeClass="dt-headPortrait-large":(this.size,this.sizeClass="dt-headPortrait-small")},mounted:function(){},beforeCreate:function(){},beforeMount:function(){},beforeUpdate:function(){},updated:function(){},beforeDestroy:function(){},destroyed:function(){},activated:function(){},methods:{}}),c=r,i=(n("0834"),n("2877")),s=Object(i["a"])(c,a,o,!1,null,"1031c22d",null);e["a"]=s.exports},"9abe":function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("van-row",{staticClass:"dt-chat"},[a("van-row",{staticClass:"dt-title",attrs:{type:"flex",align:"center"}},[a("van-col",{attrs:{span:"2"}},[a("van-image",{staticClass:"dt-back",attrs:{fit:"contain",src:n("9c21"),onclick:"history.back(-1);"}})],1),a("van-col",{attrs:{span:"20"}},[a("p",{staticClass:"dt-chat-name"},[t._v("选择好友")])])],1),a("van-row",{staticClass:"dt-content"},[a("el-tree",{ref:"tree",attrs:{props:t.props,load:t.loadNode,"show-checkbox":"",lazy:""},scopedSlots:t._u([{key:"default",fn:function(e){var n=e.data;return a("div",{staticClass:"custom-tree-node"},["orgMember"===n.dataType?a("div",{staticStyle:{display:"inline-block"}},[a("headPortrait",{attrs:{size:"small",username:n.name}})],1):t._e(),a("div",{staticStyle:{display:"inline-block","margin-left":"7px"}},[t._v(t._s(n.name))])])}}])})],1),a("van-row",{staticClass:"dt-buttonBox"},[a("van-button",{staticClass:"dt-submitButton",staticStyle:{"background-color":"#5870f8",color:"white",height:"30px"},on:{click:t.createConversation}},[t._v("确定")])],1)],1)},o=[],r=(n("4160"),n("a15b"),n("fb6a"),n("159b"),n("96cf"),n("1da1")),c=n("5d41"),i=n("b9f1"),s=n("3089"),u=n("c443"),d={props:["username"],components:{headPortrait:c["a"]},filters:{filtName:function(t){return t.length>2?t.slice(t.length-2,t.length):t}},data:function(){return{contactList:[],node:{id:0,children:[]},props:{label:"name",children:"zones",isLeaf:this.judgeLeaf},list:[]}},computed:{},watch:{},created:function(){},mounted:function(){},beforeCreate:function(){},beforeMount:function(){},beforeUpdate:function(){},updated:function(){},beforeDestroy:function(){},destroyed:function(){},activated:function(){},methods:{judgeLeaf:function(t){return void 0===t.childNum||0===t.childNum||!(void 0!==t.childNum&&t.childNum>0)&&void 0},loadNode:function(t,e){var n=this;0===t.level&&n.getNodes("0").then((function(t){return e(t.data)})),t.level>0&&n.getNodes(t.data.id).then((function(t){return e(t.data)}))},Home:function(){this.$router.push({name:"Home"})},getNodes:function(t){var e={id:t,uid:JSON.parse(localStorage.getItem("userInfo")).uid,expandMember:!0};return Object(i["a"])(e)},fetchNodes:function(t){var e=this;return Object(r["a"])(regeneratorRuntime.mark((function n(){var a,o;return regeneratorRuntime.wrap((function(n){while(1)switch(n.prev=n.next){case 0:if(a={id:t.id,uid:JSON.parse(localStorage.getItem("userInfo")).uid,expandMember:!0},o=[],!(0===t.id||t.childNum>0)){n.next=5;break}return n.next=5,Object(i["a"])(a).then((function(n){n.data.forEach((function(t){e.fetchNodes(t),o.push(t)})),t.children=o}));case 5:case"end":return n.stop()}}),n)})))()},transformData:function(){this.contactList=this.node.children},createConversation:function(){var t=this,e=this.$refs.tree.getCheckedNodes();if(e.forEach((function(e){"orgMember"===e.dataType&&t.list.push(e.id)})),0===this.list.length)Object(s["Toast"])("发起会话至少需要选中一人");else if(1===this.list.length){var n={};n.uid=JSON.parse(localStorage.getItem("userInfo")).uid,n.objectId=this.list[0],Object(u["b"])(n).then((function(e){0===e.code?(Object(s["Toast"])("会话创建成功"),t.$router.go(-1)):1301===e.code?Object(s["Toast"])("不能给自己发起会话"):1201===e.code?(Object(s["Toast"])("该会话已存在"),t.$router.go(-1)):Object(s["Toast"])("会话创建失败，请稍后再试")}))}else{var a={};a.uid=JSON.parse(localStorage.getItem("userInfo")).uid,a.objectIds=this.list.join(","),Object(u["a"])(a).then((function(e){0===e.code?(Object(s["Toast"])("会话创建成功"),t.$router.go(-1)):Object(s["Toast"])("会话创建失败，请稍后再试")}))}}}},l=d,f=(n("e1a0"),n("2877")),h=Object(f["a"])(l,a,o,!1,null,"7bc407c4",null);e["default"]=h.exports},"9c21":function(t,e){t.exports="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAQCAYAAAAvf+5AAAAA5klEQVQoU4XSMS5EURiG4fdlCWIBMsEuJiahGzRaBckUFkBCo5haYQcajSgUtCIkqCUqKxAbEIpPjtyRK3fuzClPnpzv/78cmXKS7AGLTnJJhsA+sNsKk5wD60BfvW/AJLPAA7AArKqvJfUfTDIPPAOfwIr6MRrtDyZZAh6B8kJ56bs+/y9M0gOugQt1Z9yCJtksADhRj9paKLBsdgmcqgetsIruAjfAlbo9Nnp0maQDPAFvQE/9aixTw3MVDtBV3xv11PAMcAcsA2vqS6PwelSSM2AL2FBvp32KY+AQGEyEVSODMsYPY2xP1hlXd/QAAAAASUVORK5CYII="},b9f1:function(t,e,n){"use strict";n.d(e,"a",(function(){return r})),n.d(e,"b",(function(){return c}));var a=n("a27e"),o=n("b5a0");function r(t){return Object(a["a"])({url:o["a"]+"/scooper-core-rest/data/contacts/orgDeptManage/listTreeDeptByParent",method:"GET",params:t})}function c(t){return Object(a["a"])({url:o["a"]+"/scooper-core-rest/data/contacts/orgMemberManage/listOrgMember",method:"GET",params:t})}},e08d:function(t,e,n){},e1a0:function(t,e,n){"use strict";n("e08d")},fb6a:function(t,e,n){"use strict";var a=n("23e7"),o=n("861d"),r=n("e8b5"),c=n("23cb"),i=n("50c4"),s=n("fc6a"),u=n("8418"),d=n("b622"),l=n("1dde"),f=n("ae40"),h=l("slice"),p=f("slice",{ACCESSORS:!0,0:0,1:2}),b=d("species"),m=[].slice,v=Math.max;a({target:"Array",proto:!0,forced:!h||!p},{slice:function(t,e){var n,a,d,l=s(this),f=i(l.length),h=c(t,f),p=c(void 0===e?f:e,f);if(r(l)&&(n=l.constructor,"function"!=typeof n||n!==Array&&!r(n.prototype)?o(n)&&(n=n[b],null===n&&(n=void 0)):n=void 0,n===Array||void 0===n))return m.call(l,h,p);for(a=new(void 0===n?Array:n)(v(p-h,0)),d=0;h<p;h++,d++)h in l&&u(a,d,l[h]);return a.length=d,a}})}}]);
//# sourceMappingURL=chunk-7c0de8e0.39e7cf8c.js.map