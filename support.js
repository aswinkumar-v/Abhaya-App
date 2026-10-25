(function(){
class DCLogic{constructor(){this.state={};}setState(p){this.state=Object.assign({},this.state||{},p);window.__dcRender&&window.__dcRender();}}
window.DCLogic=DCLogic;
const HOLE=/\{\{\s*([^}]+?)\s*\}\}/g;
function lookup(path,scopes){
  if(path==='true')return true;if(path==='false')return false;
  const parts=path.split('.');
  for(let i=scopes.length-1;i>=0;i--){const s=scopes[i];if(s&&typeof s==='object'&&parts[0] in s){let v=s[parts[0]];for(const p of parts.slice(1)){v=v==null?undefined:v[p];}return v;}}
  return undefined;
}
function proc(node,scopes){
  const kids=[...node.childNodes];
  for(const n of kids){
    if(n.nodeType===3){if(HOLE.test(n.nodeValue)){HOLE.lastIndex=0;n.nodeValue=n.nodeValue.replace(HOLE,(m,p)=>{const v=lookup(p,scopes);return v==null?'':String(v);});}HOLE.lastIndex=0;continue;}
    if(n.nodeType!==1)continue;
    const ln=n.localName;
    if(ln==='sc-for'){
      const lm=(n.getAttribute('list')||'').match(/\{\{\s*([^}]+?)\s*\}\}/);const list=lm?lookup(lm[1],scopes):[];const as=n.getAttribute('as');
      const frag=document.createDocumentFragment();
      (list||[]).forEach((item,idx)=>{const w=document.createElement('div');for(const c of n.childNodes)w.appendChild(c.cloneNode(true));proc(w,scopes.concat([{[as]:item}]));while(w.firstChild)frag.appendChild(w.firstChild);});
      if(n.namespaceURI==='http://www.w3.org/2000/svg'){/* svg children cloned into div lose ns; rebuild */}
      n.replaceWith(frag);continue;
    }
    if(ln==='sc-if'){
      const vm=(n.getAttribute('value')||'').match(/\{\{\s*([^}]+?)\s*\}\}/);let v=vm?lookup(vm[1],scopes):false;
      if(v&&v!=='false'){proc(n,scopes);n.replaceWith(...n.childNodes);}else n.remove();continue;
    }
    for(const a of [...n.attributes]){
      if(!a.value.includes('{{'))continue;
      const whole=a.value.match(/^\{\{\s*([^}]+?)\s*\}\}$/);
      if(whole){const v=lookup(whole[1],scopes);
        if(a.name.startsWith('on')){n.removeAttribute(a.name);if(typeof v==='function')n.addEventListener(a.name.slice(2).toLowerCase(),v);continue;}
        if(v==null){n.removeAttribute(a.name);}else n.setAttribute(a.name,String(v));
      }else n.setAttribute(a.name,a.value.replace(HOLE,(m,p)=>{const v=lookup(p,scopes);return v==null?'':String(v);}));
    }
    proc(n,scopes);
  }
}
document.addEventListener('DOMContentLoaded',()=>{
  const x=document.querySelector('x-dc');if(!x)return;
  const h=x.querySelector('helmet');if(h)document.head.insertAdjacentHTML('beforeend',h.innerHTML);
  const tpl=x.innerHTML.replace(/<helmet>[\s\S]*?<\/helmet>/,'');
  const sc=document.querySelector('script[data-dc-script]');
  let comp={renderVals:()=>({}),state:{}};
  try{const C=new Function('DCLogic',sc.textContent+';return Component;')(DCLogic);comp=new C();comp.state=comp.state||{};}catch(e){window.__err=String(e);}
  const host=document.createElement('div');host.id='dchost';x.replaceWith(host);
  window.__dcRender=()=>{const pg=host.querySelector('.page'),st=pg?pg.scrollTop:0,ae=document.activeElement,fid=ae&&ae.id;let vals={};try{vals=comp.renderVals()||{};}catch(e){window.__err=String(e);}
    const t=document.createElement('template');t.innerHTML=tpl;proc(t.content,[vals]);host.replaceChildren(t.content);const p2=host.querySelector('.page');if(p2)p2.scrollTop=st;if(fid){const f=document.getElementById(fid);if(f)f.focus();}};
  window.__dcRender();window.__ready=true;
});
})();
