import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { bankService } from '../services/bankService';
import './BankList.css';

function BankList() {
  const [banks, setBanks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchBanks();
  }, []);

  const fetchBanks = async () => {
    try {
      setLoading(true);
      const data = await bankService.getAllBanks();
      setBanks(data);
    } catch (err) {
      setError('Failed to fetch banks');
      console.error('Error fetching banks:', err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="loading-container">
        <div className="loading-spinner"></div>
        <p>Loading banks...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="error-container">
        <p className="error-message">{error}</p>
        <button onClick={fetchBanks} className="btn btn-primary">
          Try Again
        </button>
      </div>
    );
  }

  return (
    <div className="bank-list">
      <div className="page-header">
        <h2>Banks</h2>
        <p>Select a bank to view its accounts and manage transactions</p>
      </div>

      <div className="banks-grid">
        {banks.map((bank) => (
          <div key={bank.id} className="bank-card">
            <div className="bank-card-header">
              <h3>{bank.name}</h3>
              <span className="bank-location">{bank.location}</span>
            </div>
            <div className="bank-card-content">
              <div className="bank-stats">
                <div className="stat">
                  <span className="stat-label">Accounts</span>
                  <span className="stat-value">{bank.accounts_count || 0}</span>
                </div>
                <div className="stat">
                  <span className="stat-label">Total Balance</span>
                  <span className="stat-value">
                    ${bank.total_balance ? bank.total_balance.toFixed(2) : '0.00'}
                  </span>
                </div>
              </div>
            </div>
            <div className="bank-card-actions">
              <Link 
                to={`/banks/${bank.id}`} 
                className="btn btn-primary"
              >
                View Accounts
              </Link>
            </div>
          </div>
        ))}
      </div>

      {banks.length === 0 && (
        <div className="empty-state">
          <p>No banks found. Create a bank to get started.</p>
        </div>
      )}
    </div>
  );
}

export default BankList;

