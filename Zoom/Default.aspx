<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Zoom.Default" %>

<%--
    * -----------------------------------------------------------------------------
    * C# Example zoom for image
    *
    * Author:      Guilherme Caldeira
    *
    * Version:     1.0
    * Updated:     -
    * -----------------------------------------------------------------------------
--%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Zoom Image Example</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style type="text/css">
        * {
            box-sizing: border-box;
        }

        .divPrincipalZoom {
            position: relative;
        }

        .imagePrincipal {
            float:left;
            width: 43.92386530014641vw; /* 600px */
        }

        .imgLente {
            position: absolute;
            background-color: transparent;
            width: 5.856515373352855vw; /* 80px */
            height: 5.856515373352855vw; /* 80px */
        }

            .imgLente:hover {
                border-width: 1px;
                border-style: solid;
                border-color: #E7E7E7;
                background-color: #FFFFFF;
                opacity: 0.5;
            }

        .imgResultado {
            border: 1px solid #d4d4d4;
            float: left;
            margin-left: 3.660322108345534vw; /* 50px */
            width: 21.96193265007321vw; /* 300px */
            height: 21.96193265007321vw; /* 300px */
        }
    </style>

    <script type="text/javascript">    

        function ExibirDiv(divOcultar) {
            var div = document.getElementById(divOcultar);
            div.style.display = 'block';
        }

        function OcultarDiv(divOcultar) {
            var div = document.getElementById(divOcultar);
            div.style.display = 'none';
        }

        function InicializaZoom(divImagem, divResultadoZoom) {
            var imgOriginal = document.getElementById(divImagem);
            var imgResultados = document.getElementById(divResultadoZoom);

            /* Cria lente: */
            var imgLente = document.createElement("DIV");
            imgLente.setAttribute("class", "imgLente");

            /* Insere lentes:*/
            imgOriginal.parentElement.insertBefore(imgLente, imgOriginal);

            /* Calcule a relação entre o resultado DIV e a lente: */
            var cx = imgResultados.offsetWidth / imgLente.offsetWidth;
            var cy = imgResultados.offsetHeight / imgLente.offsetHeight;

            /* Defina as propriedades de segundo plano para o resultado DIV: */
            imgResultados.style.backgroundImage = "url('" + imgOriginal.src + "')";
            imgResultados.style.backgroundSize = CalculaVW(imgOriginal.width * cx) + "vw " + CalculaVW(imgOriginal.height * cy) + "vw";

            /* Executar uma função quando alguém move o cursor sobre a imagem ou a lente: */
            imgLente.addEventListener("mousemove", MovimentaLentes);
            imgOriginal.addEventListener("mousemove", MovimentaLentes);

            /* E também para telas de toque: */
            imgLente.addEventListener("touchmove", MovimentaLentes);
            imgOriginal.addEventListener("touchmove", MovimentaLentes);

            OcultarDiv(divResultadoZoom);

            function MovimentaLentes(e) {
                /* Impede quaisquer outras ações que possam ocorrer ao mover a imagem: */
                e.preventDefault();

                /* Obtenha as posições X e Y do cursor: */
                var pos = RetornaPosicaoCursos(e);

                /* Calcular a posição da lente: */
                var x = pos.x - (imgLente.offsetWidth / 2);
                var y = pos.y - (imgLente.offsetHeight / 2);

                /* Impede que a lente seja posicionada fora da imagem: */
                if (x > imgOriginal.width - imgLente.offsetWidth) { x = imgOriginal.width - imgLente.offsetWidth; }
                if (x < 0) { x = 0; }
                if (y > imgOriginal.height - imgLente.offsetHeight) { y = imgOriginal.height - imgLente.offsetHeight; }
                if (y < 0) { y = 0; }

                /* Defina a posição da lente: */
                imgLente.style.left = CalculaVW(x) + "vw";
                imgLente.style.top = CalculaVW(y) + "vw";

                /* Exibir o que a lente "vê": */
                imgResultados.style.backgroundPosition = "-" + CalculaVW(x * cx) + "vw -" + CalculaVW(y * cy) + "vw";
            }

            function RetornaPosicaoCursos(e) {

                var a, x = 0, y = 0;
                e = e || window.event;

                /* Obtenha as posições X e Y da imagem: */
                a = imgOriginal.getBoundingClientRect();

                /* Calcule as coordenadas X e Y do cursor em relação à imagem:*/
                x = e.pageX - a.left;
                y = e.pageY - a.top;

                /* Considere qualquer rolagem de página: */
                x = x - window.pageXOffset;
                y = y - window.pageYOffset;

                return { x: x, y: y };
            }
        }

        function CalculaVW(ValuePixel) {
            return (ValuePixel / 1366) * 100;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="divPrincipalZoom">
            <a href="#" onmouseover="ExibirDiv('imgZoom');" onmouseout="OcultarDiv('imgZoom');">
                <asp:Image id="imgPincipal" runat="server" ImageAlign= "Middle" ImageUrl="~/PROD_210.jpg" alt="harley-davidson" class="imagePrincipal" />
            </a>
            <div id="imgZoom" runat="server" class="imgResultado"></div>
        </div>
    </form>

    <script>
        var ImageOriginal = '<%= imgPincipal.ClientID %>';
        var ImageZoom = '<%= imgZoom.ClientID %>';

        // Inicia o zoom;
        InicializaZoom(ImageOriginal, ImageZoom);
    </script>
</body>
</html>
