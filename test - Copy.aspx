<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Quy trình 1</title>
  <style>
    :root {
      --bg:#ffffff; --nav:#f4ebdd; --text:#222;
      --card:#ffffff; --muted:#555;
      --accent:#a87d48; --accent-2:#d27d2d;
      --radius:12px; --shadow:0 4px 18px rgba(0,0,0,.08);
    }
    body{margin:0;font-family:"Segoe UI",sans-serif;background:var(--bg);color:var(--text);}
    .navbar{background:linear-gradient(180deg,var(--nav) 0%,#ffffff 100%);
      color:var(--text);height:80px;padding:0 24px;
      display:flex;justify-content:space-between;align-items:center;box-shadow:var(--shadow);}
    .logo img{height:80px;object-fit:contain;}
    .dept{font-size:14px;font-weight:500;}
    .container{max-width:1600px;margin:30px auto;padding:0 20px;}
    h1{margin:20px 0;font-size:22px;}
    select{padding:8px 12px;font-size:14px;border-radius:6px;border:1px solid #ccc;}

    table{border-collapse:collapse;width:100%;background:var(--card);box-shadow:var(--shadow);
      border-radius:var(--radius);overflow:hidden;margin-top:20px;table-layout:fixed;}
    th,td{border:1px solid #eee;padding:10px;font-size:14px;vertical-align:top;word-wrap:break-word;}
    th{background:#f9f6f0;color:var(--text);}

    th:nth-child(1), td:nth-child(1) {width:18%;}
    th:nth-child(2), td:nth-child(2) {width:15%;}
    th:nth-child(3), td:nth-child(3) {width:10%;}
    th:nth-child(4), td:nth-child(4) {width:10%;}
    th:nth-child(5), td:nth-child(5) {width:12%;}
    th:nth-child(6), td:nth-child(6) {width:25%;}
    th:nth-child(7), td:nth-child(7) {width:10%;}

    textarea.result-input{width:100%;min-height:80px;border:1px solid #ccc;
      border-radius:6px;padding:6px;resize:vertical;font-family:"Segoe UI",sans-serif;font-size:14px;}
    .btn{margin-top:6px;padding:6px 12px;border:0;border-radius:var(--radius);
      cursor:pointer;font-weight:600;color:#fff;}
    .btn-next{background:var(--accent);} .btn-edit{background:var(--accent-2);}
    .btn:hover{opacity:0.9;}
    tr.hidden{display:none;} .step-title{background:#f2eee7;font-weight:700;text-align:center;}
    .hidden{display:none !important;}

    .actions{margin:20px 0;display:flex;gap:12px;align-items:center;}
    .actions button{background:#2196f3;color:#fff;border:0;padding:8px 14px;border-radius:6px;cursor:pointer;}
    .actions button:hover{opacity:0.9;}

    #summaryTable{margin-top:20px;border-collapse:collapse;width:100%;background:#fafafa;}
    #summaryTable th,#summaryTable td{border:1px solid #ddd;padding:8px;text-align:left;}
    #summaryTable th{background:#eee;}
  </style>
</head>
<body>
  <div class="navbar">
    <div class="logo"><img src="photo/logo-nhnnvn-3-1129x800.webp" alt="Logo"></div>
    <div class="dept" id="deptName">Phòng ban: Kế toán</div>
  </div>

  <div class="container">
    <h1>Phê duyệt/có ý kiến về Kế hoạch tuyển dụng công chức loại D</h1>

    <!-- Dropdown chọn trang -->
    <label for="processSelect"><b>Chọn quy trình:</b></label>
    <select id="processSelect">
      <option value="test.html" selected>Quy trình 1</option>
      <option value="test1.html">Quy trình 2</option>
      <option value="test2.html">Quy trình 3</option>
    </select>

    <!-- Export / Import CSV -->
    <div class="actions">
      <button onclick="exportCSV()">📥 Tải CSV (1 dòng/tờ trình)</button>
      <input type="file" id="importFile" accept=".csv" onchange="importCSV(event)">
    </div>

    <div id="processTable"></div>
    <div id="summary"></div>
  </div>

<script>
document.getElementById("processSelect")
  .addEventListener("change", e => window.location.href = e.target.value);

const processData = [
  {title:"Bước 1: Tiếp nhận Tờ trình của đơn vị",sub:[
    {noidung:"Tiếp nhận Tờ trình", nguoi:"Văn thư", cho:"0,5 ngày"},
    {noidung:"Tiếp nhận Tờ trình", nguoi:"Lãnh đạo Vụ", cho:"01 ngày"},
    {noidung:"Tiếp nhận Tờ trình", nguoi:"Lãnh đạo Phòng", xuly:"0,5 ngày"},
    {noidung:"Tiếp nhận Tờ trình", nguoi:"Công chức phụ trách", xuly:"0,5 ngày"}
  ]},

  {title:"Bước 2: Rà soát báo cáo, kiến nghị",sub:[
    {noidung:"Rà soát hồ sơ đề cử", nguoi:"Công chức phụ trách", xuly:"0,5 ngày",
     type:"decision2", revealCount:2},
    {noidung:"→ Công chức trao đổi với NHNN", nguoi:"Công chức phụ trách", xuly:"0,5 ngày"},
    {noidung:"→ NHNN chi nhánh bổ sung hồ sơ", nguoi:"NHNN chi nhánh", cho:"02 ngày"}
  ]},

  {title:"Bước 3: Trình lãnh đạo Phòng phương án xử lý",sub:[
    {noidung:"Trình phương án xử lý", nguoi:"Công chức phụ trách", xuly:"0,5 ngày"},
    {noidung:"Lãnh đạo Phòng xem xét", nguoi:"Lãnh đạo Phòng", xuly:"0,5 ngày",
     type:"decision3", revealCount:2},
    {noidung:"→ Công chức chỉnh sửa", nguoi:"Công chức phụ trách", xuly:"0,5 ngày"},
    {noidung:"→ Trình lại Lãnh đạo Phòng", nguoi:"Lãnh đạo Phòng", xuly:"0,5 ngày"}
  ]},

  {title:"Bước 4: Trình Vụ trưởng",sub:[
    {noidung:"Trình phương án xử lý", nguoi:"Lãnh đạo Vụ", cho:"01 ngày"}
  ]},

  {title:"Bước 5: Phát hành văn bản",sub:[
    {noidung:"Phát hành văn bản", nguoi:"Văn thư", cho:"0,5 ngày"}
  ]}
];

function renderProcess(){
  let html = `<table>
    <thead><tr>
      <th>Nội dung thực hiện</th>
      <th>Người thực hiện/Phê duyệt</th>
      <th>Thời gian xử lý</th>
      <th>Thời gian chờ</th>
      <th>Danh mục văn bản dự thảo</th>
      <th>Kết quả</th>
      <th>Ngày hoàn thành</th>
    </tr></thead><tbody>`;
  processData.forEach((step,s)=>{
    html += `<tr class="step-title"><td colspan="7">${step.title}</td></tr>`;
    step.sub.forEach((row,r)=>{
      const id=`s${s}r${r}`;
      html += `<tr class="${(s===0&&r===0)?'':'hidden'}" id="${id}">
        <td>${row.noidung}</td>
        <td>${row.nguoi||""}</td>
        <td>${row.xuly||""}</td>
        <td>${row.cho||""}</td>
        <td>${row.vanban||""}</td>
        <td>
          <textarea class="result-input" id="res-${id}" placeholder="Nhập kết quả"></textarea>
          ${
            row.type==="decision2" ? 
              `<button class="btn btn-next" onclick="decisionStep('${id}',${s},${r},true)">Phù hợp</button>
               <button class="btn btn-next" onclick="decisionStep('${id}',${s},${r},false)">Chưa phù hợp</button>`
            : row.type==="decision3" ?
              `<button class="btn btn-next" onclick="decisionStep('${id}',${s},${r},true)">Thống nhất</button>
               <button class="btn btn-next" onclick="decisionStep('${id}',${s},${r},false)">Chưa thống nhất</button>`
            :
              `<button class="btn btn-next" id="btn-next-${id}" onclick="completeStep('${id}',${s},${r})">Chuyển ▶</button>`
          }
          <button class="btn btn-edit hidden" id="btn-edit-${id}" onclick="editStep('${id}',${s},${r},'${row.nguoi||""}')">✏️ Chỉnh sửa</button>
        </td>
        <td id="time-${id}"></td>
      </tr>`;
    });
  });
  html+=`</tbody></table>`;
  document.getElementById("processTable").innerHTML=html;
}

function formatDate(d){
  return d.toLocaleDateString("vi-VN",{day:"2-digit",month:"2-digit",year:"numeric"})+" "+
         d.toLocaleTimeString("vi-VN",{hour:"2-digit",minute:"2-digit",second:"2-digit"});
}

function completeStep(id,s,r){
  document.getElementById(`time-${id}`).textContent=formatDate(new Date());
  document.getElementById(`res-${id}`).readOnly=true;
  document.getElementById(`btn-next-${id}`)?.classList.add("hidden");
  document.getElementById(`btn-edit-${id}`).classList.remove("hidden");

  const nextRow=document.getElementById(`s${s}r${r+1}`);
  if(nextRow){ nextRow.classList.remove("hidden"); updateSummary(); return; }
  const nextStep=document.getElementById(`s${s+1}r0`);
  if(nextStep) nextStep.classList.remove("hidden");
  updateSummary();
}

function decisionStep(id,s,r,isPositive){
  document.getElementById(`time-${id}`).textContent = formatDate(new Date());
  document.getElementById(`res-${id}`).readOnly = true;
  document.getElementById(`btn-edit-${id}`).classList.remove("hidden");

  if(isPositive){
    const nextStep = document.getElementById(`s${s+1}r0`);
    if(nextStep) nextStep.classList.remove("hidden");
  } else {
    const nextRow = document.getElementById(`s${s}r${r+1}`);
    if(nextRow) nextRow.classList.remove("hidden");
  }
  updateSummary();
}

function editStep(id,s,r,nguoi){
  if(!confirm("⚠️ Sửa bước này? Các bước sau sẽ bị xóa."))return;
  const pass=prompt(`Nhập passcode (tên người: ${nguoi})`);
  if(pass!==nguoi){alert("❌ Sai passcode");return;}
  for(let i=s;i<processData.length;i++){
    const rows=processData[i].sub;
    for(let j=(i===s? r+1:0); j<rows.length;j++){
      const rid=`s${i}r${j}`;
      if(document.getElementById(rid)){
        document.getElementById(rid).classList.add("hidden");
        document.getElementById(`res-${rid}`).value="";
        document.getElementById(`time-${rid}`).textContent="";
        document.getElementById(`res-${rid}`).readOnly=false;
        document.getElementById(`btn-next-${rid}`)?.classList.remove("hidden");
        document.getElementById(`btn-edit-${rid}`).classList.add("hidden");
      }
    }
  }
  document.getElementById(`res-${id}`).readOnly=false;
  document.getElementById(`btn-next-${id}`)?.classList.remove("hidden");
  document.getElementById(`btn-edit-${id}`).classList.add("hidden");
  document.getElementById(`time-${id}`).textContent="";
  updateSummary();
}

// ===== Parse dd/MM/yyyy HH:mm:ss =====
function parseVNDate(str){
  if(!str) return null;
  const [date,time]=str.split(" ");
  if(!date||!time) return null;
  const [d,m,y]=date.split("/").map(Number);
  const [hh,mm,ss]=time.split(":").map(Number);
  return new Date(y,m-1,d,hh,mm,ss);
}

function fmt(sec){
  const d=Math.floor(sec/86400); sec%=86400;
  const h=Math.floor(sec/3600); sec%=3600;
  const m=Math.floor(sec/60); const s=Math.floor(sec%60);
  return `${d} ngày ${h} giờ ${m} phút ${s} giây`;
}

// ===== Summary =====
function updateSummary(){
  const rows=[];
  processData.forEach((step,s)=>{
    step.sub.forEach((row,r)=>{
      const t=document.getElementById(`time-s${s}r${r}`)?.textContent;
      if(t){
        const dt=parseVNDate(t);
        if(dt) rows.push({nguoi:row.nguoi,time:dt});
      }
    });
  });
  if(rows.length<2) return;

  const grouped={};
  for(let i=1;i<rows.length;i++){
    const prev=rows[i-1], curr=rows[i];
    const diff=(curr.time - prev.time)/1000;
    if(!grouped[curr.nguoi]) grouped[curr.nguoi]=0;
    grouped[curr.nguoi]+=diff;
  }
  let total=0; Object.values(grouped).forEach(v=>total+=v);

  let html=`<h2>⏱ Thống kê thời gian</h2><table id="summaryTable"><tr><th>Người</th><th>Tổng TG</th></tr>`;
  for(const [nguoi,sec] of Object.entries(grouped)){
    html+=`<tr><td>${nguoi}</td><td>${fmt(sec)}</td></tr>`;
  }
  html+=`<tr><th>Tổng quy trình</th><th>${fmt(total)}</th></tr></table>`;
  document.getElementById("summary").innerHTML=html;
}

// CSV export/import giữ nguyên code cũ ở đây
function exportCSV(){ /* ... */ }
function importCSV(e){ /* ... */ }

renderProcess();
</script>
</body>
</html>
