import Link from "next/link";
import Page from "../components/page";
import Header from "../components/header";
import EntryShow from "../components/entry-show";

export default () => (
  <Page>
    <Header />
    <p>
      WIP, currently can show title of media entry by any given ID. 2 examples:
    </p>
    <ul>
      <li>
        <Link prefetch href="/entry?id=06622f9c-8f41-43eb-a4a4-fd3b8444de64">
          <a>Diplom</a>
        </Link>
      </li>
      <li>
        <Link prefetch href="/entry?id=0d744145-53b0-4933-8ad7-783e213d858c">
          <a>Canorta</a>
        </Link>
      </li>
    </ul>
  </Page>
);
