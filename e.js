<!DOCTYPE html>
<html lang="<%= doctype %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= head.title %></title>
</head>
<body>
    <header>
        <h1><%= body.header.h1 %></h1>
    </header>
    <section>
        <% body.sections.forEach(function(section) { %>
            <p><%= section.p %></p>
        <% }); %>
    </section>
    <footer>
        <p><%= body.footer.p %></p>
    </footer>
</body>
</html>
