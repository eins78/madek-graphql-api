import Page from "../components/page";
import Header from "../components/header";
import EntryShow from "../components/entry-show";

class EntryPage extends React.Component {
  static async getInitialProps({ query }) {
    return { id: query.id };
  }
  render({ props } = this) {
    console.log(props);
    return (
      <Page>
        <Header />
        <EntryShow entryId={props.id} />
      </Page>
    );
  }
}

export default EntryPage;
