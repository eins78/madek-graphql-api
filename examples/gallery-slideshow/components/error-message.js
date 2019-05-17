export default ({ message, details }) => (
  <aside className="error-message">
    {message}
    <pre className="error-message-details">{JSON.stringify(details, 0, 2)}</pre>
  </aside>
);
