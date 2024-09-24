var n={};var r=function rafSchd(n){var r=[];var a=null;var e=function wrapperFn(){for(var e=arguments.length,l=new Array(e),t=0;t<e;t++)l[t]=arguments[t];r=l;a||(a=requestAnimationFrame((function(){a=null;n.apply(void 0,r)})))};e.cancel=function(){if(a){cancelAnimationFrame(a);a=null}};return e};n=r;var a=n;export default a;

