<%@ Language="VBScript" CodePage="65001" %>
<% Response.CharSet = "UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>출석부</title>
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-hover: #1d4ed8;
            --background-color: #f8fafc;
            --text-color: #1e293b;
            --border-color: #e2e8f0;
        }
        
        body { 
            font-family: 'Malgun Gothic', sans-serif; 
            margin: 0; 
            padding: 0; 
        
            background: #f5f5f5;
            color: var(--text-color);
            font-size: 14px;
        }
        
        .header { 
            background: #fff; 
            padding: 20px 40px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .header-left { 
            flex: 1; 
            display: flex; 
            align-items: center; 
        }
        
        .header-right { 
            flex: 1; 
            display: flex; 
            justify-content: flex-end; 
            align-items: center; 
        }
        
        .header h1 { 
            font-size:26px; 
            margin: 0; 
            font-weight: 600;
            color: var(--text-color);
            letter-spacing: -0.5px;
        }
        
        .search-box { 
            display: flex; 
            align-items: center; 
            background: var(--background-color);
            border: 1px solid var(--border-color);
            border-radius: 8px; 
            padding: 8px 16px; 
            width: 300px;
            transition: all 0.2s ease;
        }
        
        .search-box:focus-within {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        .search-box input { 
            border: none; 
            background: transparent; 
            padding: 8px; 
            width: 100%; 
            outline: none;
            font-size: 15px;
            color: var(--text-color);
        }
        
        .search-box input::placeholder {
            color: #94a3b8;
        }
        
        .container { 
            max-width: 1200px; 
            margin: 40px auto; 
            padding: 0 20px; 
        }
        
        .attendance-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 24px;
        }
        
        .attendance-title { 
            font-size:20px; 
            font-weight: 600;
            color: var(--text-color);
            letter-spacing: -0.5px;
        }
        
        .add-button { 
            background: var(--primary-color);
            color: #fff; 
            border: none; 
            border-radius: 8px; 
            padding: 12px 24px; 
            cursor: pointer; 
            display: flex; 
            align-items: center;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        
        .add-button:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }
        
        .add-button span { 
            margin-left: 8px;
        }
        
        table { width:100%; border-collapse:collapse; background:#fff; box-shadow:0 1px 3px rgba(0,0,0,0.1);}
        th { text-align:left; padding:12px 15px; background:#f8f9fa; border-bottom:1px solid #ddd; font-weight:normal; color:#666; font-size:14px; }
        td { padding:12px 15px; border-bottom:1px solid #eee; font-size:14px; }
        tr:hover { background:#f5f5f5; cursor:pointer; }
        .arrow-icon { float:right; font-size:18px; color:#999; }
        .modal { display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background-color:rgba(0,0,0,0.5); }
        .modal-content { background-color:#fff; margin:3% auto; padding:0; width:90%; max-width:600px; border-radius:8px; box-shadow:0 4px 20px rgba(0,0,0,0.3); max-height:90vh; overflow-y:auto; }
        .modal-header { background:#fff; padding:20px 30px; border-bottom:1px solid #ddd; display:flex; justify-content:space-between; align-items:center; border-radius:8px 8px 0 0; }
        .modal-title { font-size:22px; font-weight:bold; margin:0; }
        .close { color:#999; font-size:28px; font-weight:bold; cursor:pointer; }
        .close:hover { color:#333; }
        .modal-body { padding:30px; }
        .form-field { margin-bottom:25px; }
        .form-field label { display:block; margin-bottom:8px; font-weight:bold; color:#666; font-size:14px; }
        .form-field input, .form-field select, .form-field textarea { padding:12px 15px; border:1px solid #ddd; border-radius:4px; background:#fff; width:100%; box-sizing:border-box; font-size:14px; }
        .form-field input:focus, .form-field select:focus, .form-field textarea:focus { outline:none; border-color:#4285f4; }
        .attendance-row { display:flex; gap:15px; }
        .attendance-row .form-field { flex: 1 1 0; min-width: 0; max-width: 50%; }
        .attendance-row .form-field select,
        .attendance-row .form-field input {
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }
        .submit-button { width:100%; padding:15px; background:#4285f4; color:#fff; border:none; border-radius:4px; cursor:pointer; font-size:15px; font-weight:bold; margin-top:10px; }
        .submit-button:hover { background:#3367d6; }
        .delete-button { width:100%; padding:15px; background:#dc3545; color:#fff; border:none; border-radius:4px; cursor:pointer; font-size:15px; font-weight:bold; margin-top:10px; }
        .delete-button:hover { background:#c82333; }
        .button-row { display:flex; gap:15px; margin-top:10px; }
        .button-row button { flex:1; }
        .error-message { color:#dc3545; background:#f8d7da; border:1px solid #f5c6cb; padding:10px; border-radius:4px; margin-bottom:15px; }
        .success-message { color:#155724; background:#d4edda; border:1px solid #c3e6cb; padding:10px; border-radius:4px; margin-bottom:15px; }
        /* 인쇄버튼만 회색으로 */
        #viewButtons .submit-button:last-child {
            background: #adb5bd;
            color: #fff;
            border: none;
        }
        #viewButtons .submit-button:last-child:hover {
            background: #868e96;
        }
        
        /* 반응형 스타일 업데이트 */
        @media screen and (max-width: 768px) {
            .header {
                padding: 16px 20px;
            }
            
            .header h1 {
                font-size: 20px;
            }
            
            .container {
                margin: 20px auto;
            }
            
            .attendance-title {
                font-size: 18px;
            }
            
            .add-button {
                padding: 10px 20px;
            }
        }

        @media screen and (max-width: 480px) {
            .header h1 {
                font-size: 18px;
            }
            
            .search-box {
                padding: 6px 12px;
            }
            
            .add-button {
                font-size: 14px;
                padding: 8px 16px;
            }
        }

        /* ...기존 스타일... */
        th, td {
            font-size: 16px;
            font-weight: bold;
        }
        /* 증빙자료, 담임교사이름 입력란만 사이즈 조정 */
#detail_evidence, #detail_teacher_name {
    width: 180px;
    min-width: 120px;
    max-width: 100%;
    box-sizing: border-box;
}

/* 디자인 개선용 추가 CSS */
.row-horizontal {
    display: flex;
    gap: 24px;
    margin-bottom: 20px;
}
.row-horizontal .form-field {
    flex: 1 1 0;
    min-width: 0;
}
.row-horizontal label {
    font-weight: 600;
    margin-bottom: 6px;
    display: block;
}
.row-horizontal select,
.row-horizontal input[type="text"] {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #ced4da;
    border-radius: 6px;
    background: #f8f9fa;
    font-size: 15px;
}

/* 상세정보 모달 전체 간격 개선용 스타일 추가 */
#detailModal .modal-body .form-field {
    margin-bottom: 12px;
}
#detailModal .modal-body label {
    margin-bottom: 4px;
}
#detailModal .modal-body {
    padding: 22px 24px;
}
    </style>
</head>
<body>
<%
Dim message, messageType
message = ""
messageType = ""

' 날짜를 Access에서 인식하는 yyyy-mm-dd 형식으로 변환
Function FormatDateForAccess(strDate)
    If IsDate(strDate) Then
        FormatDateForAccess = Year(strDate) & "-" & Right("0" & Month(strDate),2) & "-" & Right("0" & Day(strDate),2)
    Else
        FormatDateForAccess = ""
    End If
End Function

If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    Dim action
    action = Request.Form("action")

    Set conn = Server.CreateObject("ADODB.Connection")
    On Error Resume Next
    conn.Open "DSN=dbyushin"

    If Err.Number = 0 Then
        On Error GoTo 0

        ' 등록 처리
        If action = "register" Then
            Dim dateValue, studentID, studentName, attendanceType, statusType, period
            dateValue = Request.Form("날짜")
            studentID = Request.Form("학번")
            studentName = Request.Form("이름")
            attendanceType = Request.Form("출결구분")
            statusType = Request.Form("출결상태")
            period = Request.Form("교시")
            reason = Request.Form("사유")
            evidence = Request.Form("증빙자료")
            writtenDate = Request.Form("작성날짜")
            teacherName = Request.Form("담임교사이름")
            Dim period1, period2
            period1 = Request.Form("기간1")
            period2 = Request.Form("기간2")

            Dim sqlDate, sqlWrittenDate, sqlPeriod1, sqlPeriod2
If IsDate(dateValue) Then
    sqlDate = "#" & FormatDateForAccess(dateValue) & "#"
Else
    sqlDate = "NULL"
End If
If IsDate(writtenDate) Then
    sqlWrittenDate = "#" & FormatDateForAccess(writtenDate) & "#"
Else
    sqlWrittenDate = "NULL"
End If
If IsDate(period1) Then
    sqlPeriod1 = "#" & FormatDateForAccess(period1) & "#"
Else
    sqlPeriod1 = "NULL"
End If
If IsDate(period2) Then
    sqlPeriod2 = "#" & FormatDateForAccess(period2) & "#"
Else
    sqlPeriod2 = "NULL"
End If

sql = "INSERT INTO 출석부 (학번, 이름, 출결구분, 출결상태, 교시, 사유, 기간1, 기간2) VALUES (" & _
      CLng(studentID) & ", " & _
      "'" & Replace(studentName, "'", "''") & "', " & _
      "'" & Replace(attendanceType, "'", "''") & "', " & _
      "'" & Replace(statusType, "'", "''") & "', " & _
      CLng(period) & ", " & _
      "'" & Replace(reason, "'", "''") & "', " & _
      sqlPeriod1 & ", " & _
      sqlPeriod2 & ")"

            On Error Resume Next
            conn.Execute sql
            If Err.Number = 0 Then
                message = "등록이 완료되었습니다."
                messageType = "success"
                Response.Redirect "출석부.asp"
            Else
                message = "등록 중 오류가 발생했습니다: " & Err.Description
                messageType = "error"
            End If
            On Error GoTo 0

        ' 수정 처리
        ElseIf action = "update" Then
            Dim origDate, origStudentID, origPeriod
            origDate = Request.Form("original_date")
            origStudentID = Request.Form("original_student_id")
            origPeriod = Request.Form("original_period")

            ' 수정 폼에서 받은 값
            period1 = Request.Form("기간1")
            period2 = Request.Form("기간2")
            studentID = Request.Form("학번")
            studentName = Request.Form("이름")
            attendanceType = Request.Form("출결구분")
            statusType = Request.Form("출결상태")
            period = Request.Form("교시")
            reason = Request.Form("사유")
            evidence = Request.Form("증빙자료")
            writtenDate = Request.Form("작성날짜")
            teacherName = Request.Form("담임교사이름")
            If IsNull(teacherName) Or teacherName = "undefined" Then
                teacherName = ""
            End If

            Dim sqlWrittenDateSet, sqlPeriod1Set, sqlPeriod2Set
            If IsDate(writtenDate) Then
                sqlWrittenDateSet = "작성날짜=#" & FormatDateForAccess(writtenDate) & "#, "
            Else
                sqlWrittenDateSet = ""
            End If
            If IsDate(period1) Then
                sqlPeriod1Set = "기간1=#" & FormatDateForAccess(period1) & "#, "
            Else
                sqlPeriod1Set = ""
            End If
            If IsDate(period2) Then
                sqlPeriod2Set = "기간2=#" & FormatDateForAccess(period2) & "#, "
            Else
                sqlPeriod2Set = ""
            End If

            sql = "UPDATE 출석부 SET " & _
                  sqlPeriod1Set & _
                  sqlPeriod2Set & _
                  "학번=" & CLng(studentID) & ", " & _
                  "이름='" & Replace(studentName, "'", "''") & "', " & _
                  "출결구분='" & Replace(attendanceType, "'", "''") & "', " & _
                  "출결상태='" & Replace(statusType, "'", "''") & "', " & _
                  "교시=" & CLng(period) & ", " & _
                  "사유='" & Replace(reason, "'", "''") & "', " & _
                  "증빙자료='" & Replace(evidence, "'", "''") & "', " & _
                  sqlWrittenDateSet & _
                  "담임교사이름='" & Replace(teacherName, "'", "''") & "' " & _
                  "WHERE 기간1=#" & FormatDateForAccess(origDate) & "# " & _
                  "AND 학번=" & CLng(origStudentID) & " " & _
                  "AND 교시=" & CLng(origPeriod)

            On Error Resume Next
            conn.Execute sql
            If Err.Number = 0 Then
                message = "수정이 완료되었습니다."
                messageType = "success"
                Response.Redirect "출석부.asp"
            Else
                message = "수정 중 오류가 발생했습니다: " & Err.Description & "<br>쿼리: " & sql
                messageType = "error"
            End If
            On Error GoTo 0
        ' 삭제 처리
        ElseIf action = "delete" Then
            origDate = Request.Form("delete_date")
            origStudentID = Request.Form("delete_student_id")
            origPeriod = Request.Form("delete_period")

            ' 값 검증
            If IsDate(origDate) And IsNumeric(origPeriod) And origStudentID <> "" Then
                sql = "DELETE FROM 출석부 " & _
                      "WHERE Format([기간1],'yyyy-mm-dd')='" & FormatDateForAccess(origDate) & "' " & _
                      "AND 학번=" & CLng(origStudentID) & " " & _
                      "AND 교시=" & CLng(origPeriod)

                On Error Resume Next
                conn.Execute sql
                If Err.Number = 0 Then
                    message = "삭제가 완료되었습니다."
                    messageType = "success"
                    Response.Redirect "출석부.asp"
                Else
                    message = "삭제 중 오류가 발생했습니다: " & Err.Description
                    messageType = "error"
                End If
                On Error GoTo 0
            Else
                message = "삭제 조건값이 올바르지 않습니다."
                messageType = "error"
            End If
        End If

        conn.Close
    Else
        message = "데이터베이스 연결 오류: " & Err.Description
        messageType = "error"
    End If
    Set conn = Nothing
End If
%>

<div class="header">
    <div class="header-left">
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <h1>출석부 관리</h1>
    </div>
    <div class="header-right">
        <div class="search-box">
            <form method="get" action="출석부.asp" style="width:100%;" id="searchForm">
                <input type="text" name="search" placeholder="학생 이름 검색"
                    value="<%= Server.HTMLEncode(Request.QueryString("search")) %>"
                    id="searchInput" autocomplete="off">
            </form>
        </div>
    </div>
</div>

<div class="container">
    <% If message <> "" Then %>
        <div class="<%= messageType %>-message"><%= Server.HTMLEncode(message) %></div>
    <% End If %>

    <div class="attendance-header">
        <div class="attendance-title">출석 목록</div>
        <button class="add-button" onclick="openRegisterModal()">
            <span style="font-size:16px;">+</span>
            <span>등록</span>
        </button>
    </div>

    <table>
        <thead>
            <tr>
                <th>학번</th>
                <th>이름</th>
                <th>출결</th>
                <th>교시</th>
                <th>사유</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
        <%
        Dim searchName, name, prevDate
        searchName = Trim(Request.QueryString("search"))
        prevDate = ""

        Set conn = Server.CreateObject("ADODB.Connection")
        On Error Resume Next
        conn.Open "DSN=dbyushin"
        If Err.Number <> 0 Then
            Response.Write("<tr><td colspan='6' style='color:red;'>데이터베이스 연결 오류: " & Server.HTMLEncode(Err.Description) & "</td></tr>")
        Else
            On Error GoTo 0
            sql = "SELECT * FROM 출석부 "
            If searchName <> "" Then
                searchName = Replace(searchName, "'", "''")
                sql = sql & " WHERE 이름 LIKE '%" & searchName & "%' "
            End If

Set rs = conn.Execute(sql)   ' ← 이 줄 추가

If rs.EOF Then
    Response.Write("<tr><td colspan='6'>검색 결과가 없습니다.</td></tr>")
Else
    Do Until rs.EOF
        hakbun = rs("학번")
        name = rs("이름")
        ' 기간1(시작일)로 묶어서 상단에 표시
        Dim currentStartDate
        currentStartDate = ""
        If Not IsNull(rs("기간1")) Then
            currentStartDate = Year(rs("기간1")) & "-" & Right("0" & Month(rs("기간1")),2) & "-" & Right("0" & Day(rs("기간1")),2)
        End If

        If prevDate <> currentStartDate Then
            Response.Write("<tr style='background:#f1f5fa;'><td colspan='6' style='font-weight:bold;font-size:16px;'>" & currentStartDate & "</td></tr>")
            prevDate = currentStartDate
        End If
        %>
        <tr onclick='openDetailModal(
"<%= rs("기간1") %>",
"<%= rs("기간2") %>",
"<%= hakbun %>",
"<%= Server.HTMLEncode(name) %>",
"<%= Server.HTMLEncode(rs("출결상태") & "") %>",
"<%= Server.HTMLEncode(rs("출결구분") & "") %>",
"<%= rs("교시") %>",
"<%= Server.HTMLEncode(rs("사유") & "") %>",
"<%= Server.HTMLEncode(rs("증빙자료") & "") %>",
"<%= Server.HTMLEncode(rs("작성날짜") & "") %>",
"<%= Server.HTMLEncode(rs("담임교사이름") & "") %>"
)'>
            <td><%= hakbun %></td>
            <td><%= Server.HTMLEncode(name) %></td>
            <td><%= Server.HTMLEncode(rs("출결상태") & "") & " / " & Server.HTMLEncode(rs("출결구분") & "") %></td>
            <td><%= rs("교시") %>교시</td>
            <td><%= Server.HTMLEncode(rs("사유") & "") %></td>
            <td><span class="arrow-icon">→</span></td>
        </tr>
    <%
    rs.MoveNext
Loop
                rs.Close
                Set rs = Nothing
            End If
            conn.Close
            Set conn = Nothing
        End If
        %>
    </tbody>
</table>
    </div>

    <!-- 등록 팝업 모달 -->
    <div id="registerModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">출결 등록</h3>
            <span class="close" onclick="closeModal('registerModal')">&times;</span>
        </div>
        <div class="modal-body">
            <form method="post" action="출석부.asp">
                <input type="hidden" name="action" value="register">
                <!-- 기간 입력란을 맨 위로 이동 -->
                <div class="form-field">
                    <label>기간 (시작일 ~ 종료일)</label>
                    <div style="display:flex; gap:8px;">
                        <input type="date" name="기간1" required>
                        <span style="align-self:center;">~</span>
                        <input type="date" name="기간2" required>
                    </div>
                </div>
                <!-- 날짜 입력란 제거 -->
                <!-- <div class="form-field>
                    <label>날짜</label>
                    <input type="date" name="날짜" required>
                </div> -->
                <div class="form-field">
                    <label>학번</label>
                    <input type="text" name="학번" id="register_hakbun" required>
                </div>
                <div class="form-field">
                    <label>이름</label>
                    <input type="text" name="이름" id="register_name" required>
                </div>
                <div class="attendance-row">
                    <div class="form-field">
                        <label>출결상태</label>
                        <select name="출결상태" required>
                            <option value="">선택하세요</option>
                            <option value="인정">인정</option>
                            <option value="미인정">미인정</option>
                            <option value="질병">질병</option>
                        </select>
                    </div>
                    <div class="form-field">
                        <label>출결구분</label>
                        <select name="출결구분" required>
                            <option value="">선택하세요</option>
                            <option value="결석">결석</option>
                            <option value="결과">결과</option>
                            <option value="지각">지각</option>
                            <option value="조퇴">조퇴</option>
                            <option value="기타">기타</option>
                        </select>
                    </div>
                </div>
                <div class="form-field">
                    <label>교시</label>
                    <input type="number" name="교시" min="1" max="10" required>
                </div>
                <div class="form-field">
                    <label>사유</label>
                    <input type="text" name="사유" maxlength="100">
                </div>
                <button type="submit" class="submit-button">등록</button>
            </form>
        </div>
    </div>
</div>

    <!-- 상세정보/수정 팝업 모달 -->
    <div id="detailModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">상세정보</h3>
                <span class="close" onclick="closeModal('detailModal')">&times;</span>
            </div>
            <div class="modal-body">
                <form id="editForm" method="post" action="출석부.asp">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="original_date" name="original_date" value="기존날짜">
                    <input type="hidden" id="original_student_id" name="original_student_id" value="기존학번">
                    <input type="hidden" id="original_period" name="original_period" value="기존교시">

                    <!-- 기간을 맨 위로 이동 -->
                    <div class="form-field">
                        <label>기간</label>
                        <div style="display:flex; gap:8px;">
                            <input type="date" id="detail_start_date" name="기간1" readonly style="background:#f8f9fa;">
                            <span style="align-self:center;">~</span>
                            <input type="date" id="detail_end_date" name="기간2" readonly style="background:#f8f9fa;">
                        </div>
                    </div>

                    <!-- 날짜 입력란 삭제 -->
                    <!--
                    <div class="form-field">
                        <label>날짜</label>
                        <input type="date" id="detail_date" name="날짜" readonly style="background:#f8f9fa;">
                    </div>
                    -->

                    <div class="form-field">
                        <label>학번</label>
                        <input type="text" id="detail_student_id" name="학번" readonly style="background:#f8f9fa;">
                    </div>
                    <div class="form-field">
                        <label>이름</label>
                        <input type="text" id="detail_name" name="이름" readonly style="background:#f8f9fa;">
                    </div>
                    <div style="display: flex; gap: 12px;">
    <div class="form-field" style="flex:1;">
        <label>출결상태</label>
        <select id="detail_status" name="출결상태" disabled style="background:#f8f9fa;">
            <option value="인정">인정</option>
            <option value="미인정">미인정</option>
            <option value="질병">질병</option>
        </select>
    </div>

    <div class="form-field" style="flex:1;">
        <label>출결구분</label>
        <select id="detail_type" name="출결구분" disabled style="background:#f8f9fa;">
            <option value="결석">결석</option>
            <option value="지각">지각</option>
            <option value="조퇴">조퇴</option>
            <option value="결과">결과</option>
            <option value="기타">기타</option>
        </select>
    </div>
</div>
                    <!-- 교시/사유 한 줄, 반반 배치 및 간격 조정 -->
<div style="display: flex; gap: 12px; margin-bottom: 14px;">
    <div class="form-field" style="flex:1; margin-bottom:0;">
        <label>교시</label>
        <input type="number" id="detail_period" name="교시" min="1" max="10" readonly style="background:#f8f9fa;">
    </div>
    <div class="form-field" style="flex:1; margin-bottom:0;">
        <label>사유</label>
        <input type="text" id="detail_reason" name="사유" maxlength="100" readonly style="background:#f8f9fa;">
    </div>
</div>
                    <div style="display: flex; align-items: flex-end; gap: 12px;">
    <div class="form-field" style="flex:1;">
        <label>담임교사</label>
        <input type="text" id="detail_teacher_name" name="담임교사이름" maxlength="20" readonly style="background:#f9f9fa; width:100%;">
    </div>
    <div class="form-field" style="flex:1;">
        <label>증빙서류</label>
        <select id="detail_evidence" name="증빙자료" disabled style="background:#f9f9fa; width:100%;">
            <option value="의사진단서">의사진단서</option>
            <option value="의사의견서/소견서">의사의견서/소견서</option>
            <option value="진료확인서">진료확인서</option>
            <option value="병원처방전">병원처방전</option>
            <option value="학부모의견서">학부모의견서</option>
            <option value="담임교사확인서">담임교사확인서</option>
        </select>
    </div>
</div>
                    <div class="form-field">
                        <label>작성날짜</label>
                        <input type="date" id="detail_written_date" name="작성날짜" readonly style="background:#f8f9fa;">
                    </div>

                    <div class="button-row" id="viewButtons">
                        <button type="button" class="submit-button" onclick="editMode()">수정</button>
                        <button type="button" class="delete-button" onclick="deleteRecord()">삭제</button>
                        <button type="button" class="submit-button" onclick="printAbsenceFormPage()">결석신고서</button>
                    </div>
                    
                    <div class="button-row" id="editButtons" style="display:none;">
                        <button type="submit" class="submit-button">저장</button>
                        <button type="button" class="submit-button" onclick="cancelEdit()" style="background:#6c757d;">취소</button>
                    </div>
                </form>
                
                <!-- 삭제용 숨겨진 폼 -->
                <form id="deleteForm" method="post" action="출석부.asp" style="display:none;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" id="delete_date" name="delete_date">
                    <input type="hidden" id="delete_student_id" name="delete_student_id">
                    <input type="hidden" id="delete_period" name="delete_period">
                </form>
            </div>
        </div>
    </div>

    <!-- 결석신고서 모달 -->
    <div id="absenceFormModal" class="modal" style="display:none;">
        <div class="modal-content" style="max-width:700px;">
            <div class="modal-header">
                <h3 class="modal-title">결석신고서 작성</h3>
                <span class="close" onclick="closeAbsenceFormModal()">&times;</span>
            </div>
            <div class="modal-body" id="absenceFormContent">
                <form method="post">
    <input type="hidden" name="absence_save" value="Y">
    <input type="hidden" name="absence_date" id="absence_date">
    <input type="hidden" name="absence_hakbun" id="absence_hakbun">
    <input type="hidden" name="absence_period" id="absence_period">
    <div class="form-field">
        <label>작성날짜</label>
        <input type="date" id="absence_written_date" name="작성날짜">
    </div>
    <div class="form-field">
        <label>증빙자료</label>
        <select id="absence_evidence" name="증빙자료">
            <option value="의사 진단서">의사 진단서</option>
            <option value="의사 의견서/소견서">의사 의견서/소견서</option>
            <option value="진료 확인서">진료 확인서</option>
            <option value="병원 처방전">병원 처방전</option>
            <option value="학부모 의견서">학부모 의견서</option>
            <option value="담임교사 확인서">담임교사 확인서</option>
        </select>
    </div>
    <div class="form-field">
        <label>담임교사 이름</label>
        <input type="text" id="absence_teacher" name="담임교사이름">
    </div>
    <button type="submit" class="submit-button">저장</button>
</form>
            </div>
        </div>
    </div>

    <!-- 출석부 상세정보 모달 등 원하는 위치에 버튼 추가 -->

    <script>
        var isEditMode = false;
        var originalData = {};

        function openRegisterModal() {
            document.getElementById('registerModal').style.display = 'block';
        }

        function openDetailModal(startDate, endDate, studentId, name, status, type, period, reason, evidence, writtenDate, teacherName) {
            // 원본 데이터 저장
            originalData = {
                startDate: startDate,
                endDate: endDate,
                studentId: studentId,
                name: name,
                status: status,
                type: type,
                period: period,
                reason: reason,
                evidence: evidence,
                writtenDate: writtenDate,
                teacherName: teacherName
            };

            // 기간(시작일~종료일)
            document.getElementById('detail_start_date').value = startDate || '';
            document.getElementById('detail_end_date').value = endDate || '';

            // 나머지 필드
            document.getElementById('detail_student_id').value = studentId ? studentId : '';
            document.getElementById('detail_name').value = name;
            document.getElementById('detail_status').value = status;
            document.getElementById('detail_type').value = type;
            document.getElementById('detail_period').value = period;
            document.getElementById('detail_reason').value = reason;
            document.getElementById('detail_evidence').value = evidence && evidence !== "" ? evidence : "의사진단서";
            document.getElementById('detail_written_date').value = writtenDate;
            document.getElementById('detail_teacher_name').value = teacherName || "";

            // 숨겨진 필드에 원본 데이터 설정 (date 대신 startDate 사용)
            document.getElementById('original_date').value = startDate;
            document.getElementById('original_student_id').value = studentId;
            document.getElementById('original_period').value = period;

            // 삭제 폼에도 데이터 설정
            document.getElementById('delete_date').value = startDate;
            document.getElementById('delete_student_id').value = studentId;
            document.getElementById('delete_period').value = period;

            // 보기 모드로 설정
            setViewMode();
            document.getElementById('detailModal').style.display = 'block';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
            if (modalId === 'detailModal') {
                setViewMode();
            }
        }

        function editMode() {
            isEditMode = true;
            document.getElementById('modalTitle').textContent = '출결 정보 수정';

            // 기간 입력란도 편집 가능하게
            document.getElementById('detail_start_date').readOnly = false;
            document.getElementById('detail_start_date').style.background = '#fff';
            document.getElementById('detail_end_date').readOnly = false;
            document.getElementById('detail_end_date').style.background = '#fff';

            // 나머지 필드
            document.getElementById('detail_student_id').readOnly = false;
            document.getElementById('detail_student_id').style.background = '#fff';
            document.getElementById('detail_name').readOnly = false;
            document.getElementById('detail_name').style.background = '#fff';
            document.getElementById('detail_status').disabled = false;
            document.getElementById('detail_status').style.background = '#fff';
            document.getElementById('detail_type').disabled = false;
            document.getElementById('detail_type').style.background = '#fff';
            document.getElementById('detail_period').readOnly = false;
            document.getElementById('detail_period').style.background = '#fff';
            document.getElementById('detail_reason').readOnly = false;
            document.getElementById('detail_reason').style.background = '#fff';
            document.getElementById('detail_evidence').disabled = false;
            document.getElementById('detail_evidence').style.background = '#fff';
            document.getElementById('detail_written_date').readOnly = false;
            document.getElementById('detail_written_date').style.background = '#fff';
            document.getElementById('detail_teacher_name').readOnly = false;
            document.getElementById('detail_teacher_name').style.background = '#fff';

            // 버튼 변경
            document.getElementById('viewButtons').style.display = 'none';
            document.getElementById('editButtons').style.display = 'flex';
        }

        function setViewMode() {
            isEditMode = false;
            document.getElementById('modalTitle').textContent = '상세정보';

            // 기간 입력란 읽기전용
            document.getElementById('detail_start_date').readOnly = true;
            document.getElementById('detail_start_date').style.background = '#f8f9fa';
            document.getElementById('detail_end_date').readOnly = true;
            document.getElementById('detail_end_date').style.background = '#f8f9fa';

            // 나머지 필드 읽기전용
            document.getElementById('detail_student_id').readOnly = true;
            document.getElementById('detail_student_id').style.background = '#f8f9fa';
            document.getElementById('detail_name').readOnly = true;
            document.getElementById('detail_name').style.background = '#f8f9fa';
            document.getElementById('detail_status').disabled = true;
            document.getElementById('detail_status').style.background = '#f8f9fa';
            document.getElementById('detail_type').disabled = true;
            document.getElementById('detail_type').style.background = '#f8f9fa';
            document.getElementById('detail_period').readOnly = true;
            document.getElementById('detail_period').style.background = '#f8f9fa';
            document.getElementById('detail_reason').readOnly = true;
            document.getElementById('detail_reason').style.background = '#f8f9fa';
            document.getElementById('detail_evidence').disabled = true;
            document.getElementById('detail_evidence').style.background = '#f8f9fa';
            document.getElementById('detail_written_date').readOnly = true;
            document.getElementById('detail_written_date').style.background = '#f8f9fa';
            document.getElementById('detail_teacher_name').readOnly = true;
            document.getElementById('detail_teacher_name').style.background = '#f8f9fa';

            document.getElementById('viewButtons').style.display = 'flex';
            document.getElementById('editButtons').style.display = 'none';
        }

        function cancelEdit() {
            // 기간 복원
            document.getElementById('detail_start_date').value = originalData.startDate;
            document.getElementById('detail_end_date').value = originalData.endDate;

            // 나머지 필드 복원
            document.getElementById('detail_student_id').value = originalData.studentId;
            document.getElementById('detail_name').value = originalData.name;
            document.getElementById('detail_status').value = originalData.status;
            document.getElementById('detail_type').value = originalData.type;
            document.getElementById('detail_period').value = originalData.period;
            document.getElementById('detail_reason').value = originalData.reason;
            document.getElementById('detail_evidence').value = originalData.evidence && originalData.evidence !== "" ? originalData.evidence : "의사진단서";
            document.getElementById('detail_written_date').value = originalData.writtenDate;
            document.getElementById('detail_teacher_name').value = originalData.teacherName;

            setViewMode();
        }

        function deleteRecord() {
            if(confirm('정말 삭제하시겠습니까?')) {
                document.getElementById('deleteForm').submit();
            }
        }

        function printAbsenceFormPage() {
            var name = document.getElementById('detail_name').value;
            var type = document.getElementById('detail_type').value;
            var teacher = document.getElementById('detail_teacher_name').value || '';
            var writtenDate = document.getElementById('detail_written_date').value || '';
            var hakbun = document.getElementById('detail_student_id').value || '';
            var reason = document.getElementById('detail_reason').value || '';
            var period1 = document.getElementById('detail_start_date').value || '';
            var period2 = document.getElementById('detail_end_date').value || '';
            var url = '결석신고서.html?name=' + encodeURIComponent(name)
                + '&type=' + encodeURIComponent(type)
                + '&teacher=' + encodeURIComponent(teacher)
                + '&writtenDate=' + encodeURIComponent(writtenDate)
                + '&hakbun=' + encodeURIComponent(hakbun)
                + '&reason=' + encodeURIComponent(reason)
                + '&period1=' + encodeURIComponent(period1)
                + '&period2=' + encodeURIComponent(period2);
            url += '&showzero=1'; // 버튼에서만 추가
            var win = window.open(url, '_blank', 'width=800,height=1100');
            if (win) {
                win.focus();
            } else {
                alert('팝업 차단이 되어 있습니다. 브라우저 팝업 차단을 해제해 주세요.');
            }
        }
    </script>
</body>
</html>