<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous" />

    <title>Todo List</title>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- Navbar -->
        <div class="col">
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">
                    <a class="navbar-brand" href="#">Navbar</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup"
                            aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
                        <div class="navbar-nav">
                            <a class="nav-link active" aria-current="page" href="#">Home</a>
                            <a class="nav-link" href="#">Features</a>
                            <a class="nav-link" href="#">Pricing</a>
                            <a class="nav-link disabled" tabindex="-1" aria-disabled="true">Disabled</a>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
        <!-- Navbar end -->

        <!-- Search Form -->
        <div class="col mt-3">
            <div class="card">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/todo/list" method="get">
                        <input type="hidden" name="size" value="${pageRequestDTO.size}" />

                        <fieldset class="border p-3 rounded mb-3">
                            <legend class="float-none w-auto px-2">Search</legend>

                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="finishedCheck" name="finished"
                                ${pageRequestDTO.finished ? "checked" : ""} />
                                <label class="form-check-label" for="finishedCheck">완료여부</label>
                            </div>

                            <div class="mb-3">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" id="typeTitle" name="types" value="t"
                                    ${pageRequestDTO.checkType("t") ? "checked" : ""} />
                                    <label class="form-check-label" for="typeTitle">제목</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" id="typeWriter" name="types" value="w"
                                    ${pageRequestDTO.checkType("w") ? "checked" : ""} />
                                    <label class="form-check-label" for="typeWriter">작성자</label>
                                </div>
                            </div>

                            <div class="mb-3">
                                <input type="text" class="form-control" name="keyword" placeholder="검색어 입력"
                                       value='<c:out value="${pageRequestDTO.keyword}"/>' />
                            </div>

                            <div class="row mb-3">
                                <div class="col">
                                    <input type="date" class="form-control" name="from" value="${pageRequestDTO.from}"
                                           placeholder="연도-월-일" />
                                </div>
                                <div class="col">
                                    <input type="date" class="form-control" name="to" value="${pageRequestDTO.to}"
                                           placeholder="연도-월-일" />
                                </div>
                            </div>

                            <div class="d-flex justify-content-end">
                                <button type="submit" class="btn btn-primary me-2">Search</button>
                                <button type="reset" class="btn btn-outline-info clearBtn">Clear</button>
                            </div>
                        </fieldset>
                    </form>
                </div>
            </div>
        </div>
        <!-- Search Form end -->

        <!-- Table and Pagination -->
        <div class="col mt-3">
            <div class="card">
                <div class="card-header">
                    Featured
                </div>
                <div class="card-body">
                    <h5 class="card-title">Special title treatment</h5>

                    <table class="table table-hover table-bordered">
                        <thead class="table-light">
                        <tr>
                            <th scope="col">Tno</th>
                            <th scope="col">Title</th>
                            <th scope="col">Writer</th>
                            <th scope="col">DueDate</th>
                            <th scope="col">Finished</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${responseDTO.dtoList}" var="dto">
                            <tr>
                                <th scope="row"><c:out value="${dto.tno}"/></th>
                                <td>
                                    <a href="${pageContext.request.contextPath}/todo/read?tno=${dto.tno}&${pageRequestDTO.link}"
                                       class="text-decoration-none" data-tno="${dto.tno}">
                                        <c:out value="${dto.title}"/>
                                    </a>
                                </td>
                                <td><c:out value="${dto.writer}"/></td>
                                <td><c:out value="${dto.dueDate}"/></td>
                                <td><c:out value="${dto.finished}"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <div class="d-flex justify-content-end">
                        <ul class="pagination flex-wrap mb-0">
                            <c:if test="${responseDTO.prev}">
                                <li class="page-item">
                                    <a class="page-link" data-num="${responseDTO.start -1}" href="#">Previous</a>
                                </li>
                            </c:if>

                            <c:forEach begin="${responseDTO.start}" end="${responseDTO.end}" var="num">
                                <li class="page-item ${responseDTO.page == num ? "active" : ""}">
                                    <a class="page-link" data-num="${num}" href="#">${num}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${responseDTO.next}">
                                <li class="page-item">
                                    <a class="page-link" data-num="${responseDTO.end + 1}" href="#">Next</a>
                                </li>
                            </c:if>
                        </ul>
                    </div>

                    <script>
                        document.querySelector(".pagination").addEventListener("click", function (e) {
                            e.preventDefault();
                            e.stopPropagation();

                            const target = e.target;
                            if (target.tagName !== 'A') return;

                            const num = target.getAttribute("data-num");
                            const formObj = document.querySelector("form");

                            // Remove existing hidden page input if exists
                            const existingPageInput = formObj.querySelector("input[name='page']");
                            if (existingPageInput) existingPageInput.remove();

                            formObj.innerHTML += `<input type='hidden' name='page' value='${num}'>`;
                            formObj.submit();
                        });

                        document.querySelector(".clearBtn").addEventListener("click", function (e) {
                            e.preventDefault();
                            e.stopPropagation();

                            window.location.href = '${pageContext.request.contextPath}/todo/list';
                        });
                    </script>

                </div>
            </div>
        </div>
        <!-- Table and Pagination end -->

    </div>

    <div class="row footer">
        <div class="row fixed-bottom" style="z-index: -100;">
            <footer class="py-1 my-1">
                <p class="text-center text-muted">Footer</p>
            </footer>
        </div>
    </div>
</div>

<!-- Bootstrap Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
        crossorigin="anonymous"></script>

</body>
</html>
