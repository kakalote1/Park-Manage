(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-049f6cab"],{"481a":function(t,e,a){"use strict";a("a8dd")},"89cc":function(t,e,a){"use strict";a.r(e);var n=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("van-row",{staticStyle:{height:"100%"}},[a("van-row",{staticClass:"dt-title",attrs:{type:"flex",align:"center"}},[a("van-col",{attrs:{span:"2"}},[a("van-icon",{staticClass:"dt-back",attrs:{name:"arrow-left"},on:{click:t.back}})],1),a("van-col",{attrs:{span:"20"}},[a("p",{staticClass:"dt-home-shouye"},[t._v("工单管理")])])],1),a("van-tabs",{model:{value:t.active,callback:function(e){t.active=e},expression:"active"}},[a("van-tab",{attrs:{title:"未处理("+t.totalCount1+")"}},[a("orderList",{attrs:{sendForm:t.form1,formType:1}})],1),a("van-tab",{attrs:{title:"已处理("+t.totalCount2+")"}},[a("orderList",{attrs:{sendForm:t.form2,formType:2}})],1),a("van-tab",{attrs:{title:"我上报工单("+t.totalCount3+")"}},[a("orderList",{attrs:{sendForm:t.form3,formType:3}})],1)],1)],1)},o=[],i=a("663e"),r=a("b87f"),c={components:{orderList:r["default"]},data:function(){return{form1:{SecunityContent:"",SecunityStatus:1,OperationBeginDate:new Date((new Date).format("yyyy-MM-ddT00:00:00")),OperationEndDate:new Date((new Date).format("yyyy-MM-ddT23:59:59")),PageSize:20,PageIndex:0},form2:{SecunityContent:"",SecunityStatus:2,OperationBeginDate:new Date((new Date).format("yyyy-MM-ddT00:00:00")),OperationEndDate:new Date((new Date).format("yyyy-MM-ddT23:59:59")),PageSize:20,PageIndex:0},form3:{SecunityContent:"",OperatorUserId:JSON.parse(localStorage.getItem("userInfo")).uid,OperationBeginDate:new Date((new Date).format("yyyy-MM-ddT00:00:00")),OperationEndDate:new Date((new Date).format("yyyy-MM-ddT23:59:59")),SecunityStatus:3,PageSize:20,PageIndex:0},totalCount1:0,totalCount2:0,totalCount3:0,active:0}},computed:{},watch:{},created:function(){},mounted:function(){this.initTotalCount(),this.active=this.$store.state.active},beforeCreate:function(){},beforeMount:function(){},beforeUpdate:function(){},updated:function(){},beforeDestroy:function(){},destroyed:function(){},activated:function(){},methods:{initTotalCount:function(){var t=this;Object(i["c"])(this.form1).then((function(e){t.totalCount1=e.Data.TotalCount})),Object(i["c"])(this.form2).then((function(e){t.totalCount2=e.Data.TotalCount})),Object(i["c"])(this.form3).then((function(e){t.totalCount3=e.Data.TotalCount}))},Home:function(){this.$router.push({name:"Home"})},back:function(){this.$store.commit("active",0),history.back(-1)}}},s=c,u=(a("481a"),a("2877")),f=Object(u["a"])(s,n,o,!1,null,"7407832c",null);e["default"]=f.exports},a8dd:function(t,e,a){}}]);
//# sourceMappingURL=chunk-049f6cab.49f8fe1e.js.map