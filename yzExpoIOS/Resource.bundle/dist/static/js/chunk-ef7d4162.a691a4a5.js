(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-ef7d4162"],{cff5:function(t,e,n){"use strict";n("e9fd")},db40:function(t,e,n){"use strict";n.r(e);var o=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("van-row",{staticStyle:{height:"100%"}},[n("van-row",{staticClass:"dt-title",attrs:{type:"flex",align:"center"}},[n("van-col",{attrs:{span:"2"}},[n("van-icon",{staticClass:"dt-back",attrs:{name:"arrow-left"},on:{click:t.back}})],1),n("van-col",{attrs:{span:"20"}},[n("p",{staticClass:"dt-home-shouye"},[t._v("签到")])])],1),n("van-row",{staticClass:"dt-content"},[n("div",{attrs:{id:"container"}}),n("div",{staticClass:"signHistory",on:{click:function(e){t.popShow=!0}}},[n("van-icon",{staticClass:"signIco",attrs:{name:"edit"}}),t._v("签到记录 ")],1),n("div",{staticClass:"dt-sign-box"},[n("van-row",{staticClass:"dt-signIn"},[n("div",{staticClass:"dt-signIn-button",on:{click:t.signIn}},[n("span",[t._v(t._s(t.statusText))])])]),n("div",{staticClass:"sign-text"},[n("div",[n("span",{staticStyle:{background:"#7CE574"}}),t._v("签到时间："+t._s(t._f("filtDate")(this.checkIn)))]),n("div",[n("span",{staticStyle:{background:"#F45A5A"}}),t._v("签退时间："+t._s(t._f("filtDate")(this.checkOut)))])])],1)]),n("van-popup",{style:{height:"50%"},attrs:{position:"bottom",round:""},model:{value:t.popShow,callback:function(e){t.popShow=e},expression:"popShow"}},[n("van-row",{staticClass:"background-image"},[n("van-row",{staticClass:"dt-table"},[n("van-calendar",{style:{height:"px2rem(500)"},attrs:{"show-title":!1,poppable:!1,"show-confirm":!1,"show-mark":!1,"min-date":t.minDate,"max-date":t.maxDate,"default-date":t.CheckDateList,type:"multiple",color:"#E3ECFD",formatter:t.formatter,readonly:""}})],1)],1)],1)],1)},a=[],i=(n("b0c0"),n("4d63"),n("ac1f"),n("25f0"),n("5319"),n("1276"),n("a27e")),s=n("a139");function r(t){return Object(i["a"])({url:s["b"]+"/msapi/v1.0/YZProjectService/tb_project_checkwork/GetPageContentByConditions",method:"post",data:t})}function c(t){return Object(i["a"])({url:s["b"]+"/msapi/v1.0/YZProjectService/tb_project_checkwork/AddItem",method:"post",data:t})}var l=n("fa20"),u=n("09cb"),d=[32.338702,119.082536],h=[32.323029,119.109109],g=[32.336605,119.106966],f=[32.327299,119.082039],p=[32.32681,119.084153],m=[32.320722,119.090813],w=[32.325379,119.092311],k=[32.323005,119.083512],S=[32.342202,119.083905],L=[32.338726,119.087902],C=[32.341955,119.087824],v=[32.338857,119.084041],D=-.002,I=.0055,y={latitude:32.328552,longitude:119.104515,address:"江苏省"},O={components:{},filters:{filtDate:function(t){return t=t.replace(new RegExp("-","gm"),"/"),"未签到"==t||"未签退"==t?t:new Date(t).format("hh:mm:ss")}},data:function(){return{information:JSON.parse(localStorage.getItem("userInfo")),formIn:{CheckUserId:JSON.parse(localStorage.getItem("userInfo")).uid,CheckUserName:JSON.parse(localStorage.getItem("userInfo")).real_name,CheckUserDept:"",CheckUserDuty:"",CheckStatus:0,CheckDate:null,CheckTime:null,longitude:"",latitude:"",Address:"",CheckResource:1,LinkPhone:JSON.parse(localStorage.getItem("userInfo")).mobile,Validity:1},formOut:{CheckUserId:JSON.parse(localStorage.getItem("userInfo")).uid,CheckUserName:JSON.parse(localStorage.getItem("userInfo")).real_name,CheckUserDuty:"",CheckStatus:1,CheckDate:null,SignOutTime:null,longitude:"",latitude:"",Address:"",CheckResource:1,LinkPhone:JSON.parse(localStorage.getItem("userInfo")).mobile,Validity:1},checkList:[],show:!1,currentDate:new Date,minDate:new Date(2021,0,1),maxDate:new Date(2030,11,31),CheckDateList:[],signOutList:[],signOutDate:[],statusText:"",contentList:[],statussss:-1,tttoday:null,checkIn:"未签到",checkOut:"未签退",in:[],out:[],phonelat:null,phonelon:null,inLat:"",inLon:"",outLat:"",outLon:"",inAddress:"未签到",outAddress:"未签退",polygon:null,popShow:!1}},computed:{},watch:{},created:function(){},mounted:function(){this.initMap(),this.getAttendance(),this.getDepartment()},beforeCreate:function(){},beforeMount:function(){},beforeUpdate:function(){},updated:function(){},beforeDestroy:function(){},destroyed:function(){},activated:function(){},methods:{initMap:function(){var t=new window.TMap.LatLng(32.3327,119.088555),e=new window.TMap.Map("container",{zoom:13.5,center:t,disableDefaultUI:!0}),n=[new window.TMap.LatLng(d[0]-D,d[1]-I),new window.TMap.LatLng(v[0]-D,v[1]-I),new window.TMap.LatLng(S[0]-D,S[1]-I),new window.TMap.LatLng(C[0]-D,C[1]-I),new window.TMap.LatLng(L[0]-D,L[1]-I),new window.TMap.LatLng(g[0]-D,g[1]-I),new window.TMap.LatLng(h[0]-D,h[1]-I),new window.TMap.LatLng(w[0]-D,w[1]-I),new window.TMap.LatLng(m[0]-D,m[1]-I),new window.TMap.LatLng(k[0]-D,k[1]-I),new window.TMap.LatLng(p[0]-D,p[1]-I),new window.TMap.LatLng(f[0]-D,f[1]-I)];new window.TMap.MultiPolygon({id:"polygon-layer",map:e,styles:{polygon:new window.TMap.PolygonStyle({color:"rgba(0,125,255,0.3)",showBorder:!1,borderColor:"#00FFFF"})},geometries:[{id:"p1",styleId:"polygon",paths:n}]});var o=0,a=0;if(window.android){var i=JSON.parse(window.android.getLocation().toLocaleString());o=i.latitude,a=i.longitude,console.log("安卓定位返回！！！",o,a)}else if(window.webkit){var s=JSON.parse(localStorage.getItem("location"));o=s.latitude,a=s.longitude;var r=Object(u["a"])(a,o);a=r[0],o=r[1],console.log("ioslonlat定位返回！！！",o,a)}else o=y.latitude,a=y.longitude,console.log("h5定位返回！！！",o,a);new window.TMap.MultiMarker({map:e,styles:{myStyle:new window.TMap.MarkerStyle({width:25,height:35,anchor:{x:16,y:32}})},geometries:[{id:"1",styleId:"myStyle",position:new window.TMap.LatLng(o-D,a-I),properties:{title:"marker1"}}]})},checkSite:function(t,e){var n=!1;return t>=h[0]&&t<=d[0]&&e>=d[1]&&e<=h[1]?(console.log("在园区范围内"),n=!0):t>=m[0]&&t<=p[0]&&e>=p[1]&&e<=m[1]?(console.log("在P1停车场范围内"),n=!0):t>=L[0]&&t<=S[0]&&e>=S[1]&&e<=L[1]?(console.log("在P4停车场范围内"),n=!0):(console.log("不再范围内"),n=!1),n},signIn:function(){if(window.android){console.log("安卓");var t=JSON.parse(window.android.getLocation().toLocaleString());console.log("安卓定位返回！！！",t),this.phonelat=t.latitude,this.phonelon=t.longitude,this.checkSite(this.phonelat,this.phonelon)?(console.log("安卓在范围内"),this.formIn.longitude=String(t.longitude),this.formOut.longitude=String(t.longitude),this.formIn.latitude=String(t.latitude),this.formOut.latitude=String(t.latitude),this.formIn.Address=String(t.address),this.formOut.Address=String(t.address),this.handleSign()):(console.warn("安卓不在签到范围内"),this.$toast({message:"不在打卡范围",position:"top"}))}else if(window.webkit){console.log("苹果");var e=JSON.parse(localStorage.getItem("location")),n=e;this.phonelat=n.latitude,this.phonelon=n.longitude,this.checkSite(this.phonelat,this.phonelon)?(console.log("IOS在范围内"),this.formIn.longitude=String(n.longitude),this.formOut.longitude=String(n.longitude),this.formIn.latitude=String(n.latitude),this.formOut.latitude=String(n.latitude),this.formIn.Address=String(n.address),this.formOut.Address=String(n.address),this.handleSign()):(console.warn("IOS不在签到范围内"),this.$toast({message:"不在打卡范围",position:"top"}))}else console.log("H5"),this.phonelat=y.latitude,this.phonelon=y.longitude,this.checkSite(this.phonelat,this.phonelon)?(console.log("H5在范围内"),this.formIn.longitude=String(y.longitude),this.formOut.longitude=String(y.longitude),this.formIn.latitude=String(y.latitude),this.formOut.latitude=String(y.latitude),this.handleSign()):(console.warn("H5不在签到范围内"),this.$toast({message:"不在打卡范围",position:"top"}))},getDepartment:function(){var t=this;Object(l["b"])((function(e){t.formIn.CheckUserDept=e.name,t.formIn.CheckUserDuty=e.name,t.formOut.CheckUserDept=e.name,t.formOut.CheckUserDuty=e.name}))},attendanceIn:function(){var t=this;console.log("新增考勤请求",this.formIn),c(this.formIn).then((function(e){console.log("新增考勤返回",e),t.getAttendance(),t.$toast.success({message:"签到成功"})}))},attendanceOut:function(){var t=this;console.log("新增考勤请求",this.formOut),c(this.formOut).then((function(e){console.log("新增考勤返回",e),t.getAttendance(),t.$toast.success({message:"签退成功"})}))},getAttendance:function(){var t=this;r({PageSize:9999999,CheckUserId:this.information.uid,PageIndex:1}).then((function(e){for(var n in console.log("获取到的数据",e),t.checkList=e.Data.ContentList,t.checkList){var o=t.checkList[n].CheckDate;t.CheckDateList.push(new Date(o))}for(var a in t.checkList){var i=t.checkList[a].SignOutTime;t.signOutList.push(new Date(i))}t.panduan()}))},handleSign:function(){var t=this;if("签到"==this.statusText){var e=new Date;console.log("签到日期",e),this.formIn.CheckTime=e,this.formIn.CheckDate=this.toDay(),this.attendanceIn()}else"签退"==this.statusText?this.$dialog.confirm({message:"确认签退"}).then((function(){var e=new Date;console.log("签退日期",e),t.formOut.SignOutTime=e,t.formOut.CheckDate=t.toDay(),t.attendanceOut()})).catch((function(){})):"已签退"==this.statusText&&this.$toast.success({message:"已签退"})},panduan:function(){var t=this;r({PageSize:99999,PageIndex:1,CheckUserId:this.information.uid,CheckDate:this.toDay()}).then((function(e){if(e.Data.ContentList)for(var n in t.contentList=e.Data.ContentList,t.contentList){var o=t.contentList[n].CheckStatus;if(0==o)t.statussss=0;else if(1==o){t.statussss=1;break}}else t.statussss=-1;-1==t.statussss?t.statusText="签到":0==t.statussss?(t.statusText="签退",r({PageSize:99999,PageIndex:1,CheckUserId:t.information.uid,CheckDate:t.toDay(),CheckStatus:0}).then((function(e){t.in=e.Data.ContentList;var n=t.in[0].CheckTime,o=new Array;o=n.split("T"),t.checkIn=o[0]+" "+o[1],t.inLon=t.in[0].longitude,t.inLat=t.in[0].latitude,t.inAddress=t.in[0].Address}))):1==t.statussss&&(t.statusText="已签退",r({PageSize:99999,PageIndex:1,CheckUserId:t.information.uid,CheckDate:t.toDay(),CheckStatus:0}).then((function(e){t.in=e.Data.ContentList;var n=t.in[0].CheckTime,o=new Array;o=n.split("T"),t.checkIn=o[0]+" "+o[1],t.inLon=t.in[0].longitude,t.inLat=t.in[0].latitude,t.inAddress=t.in[0].Address})),r({PageSize:99999,PageIndex:1,CheckUserId:t.information.uid,CheckDate:t.toDay(),CheckStatus:1}).then((function(e){t.out=e.Data.ContentList;var n=t.out[0].SignOutTime,o=new Array;o=n.split("T"),t.checkOut=o[0]+" "+o[1],t.outLon=t.out[0].longitude,t.outLat=t.out[0].latitude,t.outAddress=t.out[0].Address})))}))},toDay:function(){var t=new Date,e=t.getFullYear(),n=t.getMonth(),o=t.getDate(),a=new Date(e,n,o);return this.tttoday=o,a},Home:function(){this.$router.push({name:"Home"})},formatter:function(t){var e=t.date.getFullYear(),n=t.date.getMonth(),o=t.date.getDate();for(var a in this.signOutList){var i=new Date(this.signOutList[a]).getFullYear(),s=new Date(this.signOutList[a]).getMonth(),r=new Date(this.signOutList[a]).getDate();e===i&&n===s&&o===r&&(t.bottomInfo="●")}return t},back:function(){this.$store.commit("active",0),history.back(-1)}}},b=O,T=(n("cff5"),n("2877")),M=Object(T["a"])(b,o,a,!1,null,"565a5c0b",null);e["default"]=M.exports},e9fd:function(t,e,n){}}]);
//# sourceMappingURL=chunk-ef7d4162.a691a4a5.js.map