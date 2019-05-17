import Document, { Head, Main, NextScript } from "next/document";

export default class CustomDocument extends Document {
  render() {
    return (
      <html>
        <Head>
          <link rel="stylesheet" href="/static/bootstrap.min.css" />
          <link rel="stylesheet" href="/static/jquery.fancybox.min.css" />
          <link rel="stylesheet" href="/static/style.css" />
        </Head>
        <body>
          <Main />
          <script src="/static/jquery.min.js" />
          <script src="/static/jquery.fancybox.min.js" />
          <NextScript />
        </body>
      </html>
    );
  }
}
