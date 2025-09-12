<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>管理者メニュー</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
    <div class="container">
        <h1>管理者メニュー</h1>
        <p>ようこそ, ${user.username}さん (管理者)</p>
        <div class="main-nav">
            <a href="attendance?action=filter">勤怠履歴管理</a>
            <a href="users?action=list">ユーザー管理</a>
            <a href="logout">ログアウト</a>
        </div>
        
        <c:if test="${not empty sessionScope.successMessage}">
            <p class="success-message"><c:out value="${sessionScope.successMessage}"/></p>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        
        <h2>勤怠履歴</h2>
        <form action="attendance" method="get" class="filter-form">
            <input type="hidden" name="action" value="filter">
            <div>
                <label for="filterUserId">ユーザーID:</label>
                <input type="text" id="filterUserId" name="filterUserId" value="<c:out value='${param.filterUserId}'/>">
            </div>
            <div>
                <label for="startDate">開始日:</label>
                <input type="date" id="startDate" name="startDate" value="<c:out value='${param.startDate}'/>">
            </div>
            <div>
                <label for="endDate">終了日:</label>
                <input type="date" id="endDate" name="endDate" value="<c:out value='${param.endDate}'/>">
            </div>
            <button type="submit" class="button">フィルタ</button>
        </form>
        
        <p class="error-message"><c:out value="${errorMessage}"/></p>
        <a href="attendance?action=export_csv&filterUserId=<c:out value='${param.filterUserId}'/> &startDate=<c:out value='${param.startDate}'/> &endDate=<c:out value='${param.endDate}'/>" class="button">勤怠履歴をCSV エクスポート</a>
        
        <h3>勤怠サマリー (合計労働時間)</h3>
        <table class="summary-table">
            <thead>
                <tr>
                    <th>ユーザーID</th>
                    <th>合計労働時間 (時間)</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="entry" items="${totalHoursByUser}">
                    <tr>
                        <td>${entry.key}</td>
                        <td>${entry.value}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty totalHoursByUser}">
                    <tr><td colspan="2">データがありません。</td></tr>
                </c:if>
            </tbody>
        </table>
        
        <h3>月別勤怠グラフ (簡易版)</h3>
        <h4>月別合計労働時間</h4>
        <pre>
            <c:forEach var="entry" items="${monthlyWorkingHours}">
                ${entry.key}: <c:forEach begin="1" end="${entry.value / 5}">*</c:forEach> ${entry.value}時間
            </c:forEach>
            <c:if test="${empty monthlyWorkingHours}">データがありません。</c:if>
        </pre>
        
        <h4>月別出勤日数</h4>
        <pre>
            <c:forEach var="entry" items="${monthlyCheckInCounts}">
                ${entry.key}: <c:forEach begin="1" end="${entry.value}">■</c:forEach> ${entry.value}日
            </c:forEach>
            <c:if test="${empty monthlyCheckInCounts}">データがありません。</c:if>
        </pre>
        
        <h3>詳細勤怠履歴</h3>
        <table>
            <thead>
                <tr>
                    <th>従業員ID</th>
                    <th>出勤時刻</th>
                    <th>退勤時刻</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="att" items="${allAttendanceRecords}">
                    <tr>
                        <td>${att.userId}</td>
                        <td>${att.checkInTime}</td>
                        <td>${att.checkOutTime}</td>
                        <td class="table-actions">
                            <form action="attendance" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete_manual">
                                <input type="hidden" name="userId" value="${att.userId}">
                                <input type="hidden" name="checkInTime" value="${att.checkInTime}">
                                <input type="hidden" name="checkOutTime" value="${att.checkOutTime}">
                                <input type="submit" value="削除" class="button danger" onclick="return confirm('本当にこの勤怠記録を削除しますか？');">
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty allAttendanceRecords}">
                    <tr><td colspan="4">データがありません。</td></tr>
                </c:if>
            </tbody>
        </table>
        
        <h2>勤怠記録の手動追加</h2>
        <form action="attendance" method="post">
            <input type="hidden" name="action" value="add_manual">
            <p>
                <label for="manualUserId">ユーザーID:</label>
                <input type="text" id="manualUserId" name="userId" required>
            </p>
            <p>
                <label for="manualCheckInTime">出勤時刻:</label>
                <input type="datetime-local" id="manualCheckInTime" name="checkInTime" required>
            </p>
            <p>
                <label for="manualCheckOutTime">退勤時刻 (任意):</label>
                <input type="datetime-local" id="manualCheckOutTime" name="checkOutTime">
            </p>
            <div class="button-group">
                <input type="submit" value="追加">
            </div>
        </form>
    </div>
</body>
</html>
