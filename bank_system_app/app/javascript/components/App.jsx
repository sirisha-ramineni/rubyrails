import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Header from './Header';
import BankList from './BankList';
import BankDetail from './BankDetail';
import AccountDetail from './AccountDetail';
import TransactionList from './TransactionList';
import './App.css';

function App() {
  return (
    <div className="app">
      <Header />
      <main className="main-content">
        <Routes>
          <Route path="/" element={<BankList />} />
          <Route path="/banks" element={<BankList />} />
          <Route path="/banks/:bankId" element={<BankDetail />} />
          <Route path="/banks/:bankId/accounts/:accountId" element={<AccountDetail />} />
          <Route path="/transactions" element={<TransactionList />} />
        </Routes>
      </main>
    </div>
  );
}

export default App;

