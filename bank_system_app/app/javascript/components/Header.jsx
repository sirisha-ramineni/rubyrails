import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import './Header.css';

function Header() {
  const location = useLocation();

  return (
    <header className="header">
      <div className="header-container">
        <div className="header-content">
          <h1 className="header-title">
            🏦 Bank Management System
          </h1>
          <nav className="header-nav">
            <Link 
              to="/" 
              className={`nav-link ${location.pathname === '/' ? 'active' : ''}`}
            >
              Home
            </Link>
            <Link 
              to="/banks" 
              className={`nav-link ${location.pathname === '/banks' ? 'active' : ''}`}
            >
              Banks
            </Link>
            <Link 
              to="/transactions" 
              className={`nav-link ${location.pathname === '/transactions' ? 'active' : ''}`}
            >
              All Transactions
            </Link>
          </nav>
        </div>
      </div>
    </header>
  );
}

export default Header;

