import Link from "next/link";
import { withRouter } from "next/router";

const Header = ({ router: { pathname } }) => (
  <header className="page-header">
    <NavLink current={pathname} href="/">
      Home
    </NavLink>
    <NavLink current={pathname} href="/about">
      About
    </NavLink>
  </header>
);

export default withRouter(Header);

const NavLink = ({ href, children, current, ...rest }) => (
  <Link {...rest} href={href}>
    <a className={current === href ? "is-active" : ""}>{children}</a>
  </Link>
);
