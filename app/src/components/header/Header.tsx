import { SessionType, useSession } from "@lens-protocol/react-web";
import { NavLink } from "react-router-dom";

import { CATEGORIES } from "../../config";
import { LoginButton, LogoutButton } from "../auth";

export function Header() {
  const { data: session } = useSession();
  return (
    <header>
      <div
        style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          maxWidth: "1600px",
          margin: "auto",
          padding: "1rem",
        }}
      >
        <span>
          <NavLink to={"/"}>
            <strong>Lens + Chainlink</strong>
          </NavLink>
        </span>
        <span>
          <img
            style={{ width: "130px", height: "130px" }}
            src="../../../lens green.svg"
          ></img>
          <img
            style={{ width: "120px", height: "120px" }}
            src="../../../Chainlink Hexagon.svg"
          ></img>
        </span>
        <div
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            gap: "1rem",
          }}
        >
          {session?.type === SessionType.WithProfile && (
            <strong>
              {session.profile.metadata?.displayName ??
                session.profile.handle?.fullHandle ??
                session.profile.id}
            </strong>
          )}

          {session?.authenticated ? <LogoutButton /> : <LoginButton />}
        </div>
      </div>

      <nav>
        {CATEGORIES.map(({ path, label }) => (
          <NavLink
            key={path}
            to={path}
            className={({ isActive }) => (isActive ? "current" : undefined)}
          >
            {label}
          </NavLink>
        ))}
      </nav>
    </header>
  );
}
