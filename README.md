# BlockLance: Stacks Blockchain Freelance Payment Platform

## 📝 Overview

This project implements a decentralized freelance payment platform using clarity smart contracts on the stacks blockchain. The platform provides a secure, transparent, and trustless way for clients and freelancers to manage work agreements, milestone traking and payments

## 🌟 Key Features

- Milestone-based job creation and tracking
- Secure payment escrow
- Built-in dispute resolution mechanism
- Transparent jb status management
- Comprehensive error handling

## 🛠️ Technology Stack

- Blockchain: Stacks
- Smart Contract Language: Clarity
- Payment Token: STX(Stacks Token)

## 📦 Contract Functionality

### Job Lifecycle

1. **Job Creation**: Clients can create jobs with:
    - Freelancer address
    - Job description
    - Total payment
    - Milestone breakdown
2. **Job Progression**
    - Job Statuses:
        - Created
        - In Progress
        - Completed
        - Disputed
        - Paid
3. **Milestone Management**
    - Freelancers mark milestones as complete
    - Clients approve milestone payments
    - Automatic payment release upon milestone approval
4. **Dispute Resolution**
    - Both client and freelancer can initiate disputes
    - Contracts owner can resolve disputes with percentage-based refunds

## 🚀 Getting Started

### Prerequisites

- Stacks Wallet
- Clarinet (for local development and testing)
- Basic understanding of clarity an Stacks blockchain

### Installation

1. Clone the repository
```bash
git clone https://github.com/Manuelshub/BlockLance.git
cd BlockLance
```

2. Install dependencies

```bash
npm install
# or 
yarn install
```

3. Set up clarinet
```bash
clarinet console
```
### Running Tests
```bash
clarinet test
```

## Smart Contract Functions

### Job Creation

- **create-job**: Initialize a new freelance job
- Parameters: freelancer, description, total payment, milestones

### Job Management

- **start-job**: Client starts the job
- **complete-milestone**: Freelancer marks a milestone complete
- **approve-milestone-payment**: Client releases milestone payment

### Dispute Handling

- **dispute-job**: Initiate a job dispute
- **resolve-dispute**: Contract owner resolves the dispute

## 🔒 Security Considerations

- Only contract owner can resolve disputes
- Access controls prevent unauthorized actions
- Milestone payments must match total job payment
- Comprehensive error handling

## 💡 Usage Example

```clarity
;; Create a job with 2 milestones
(create-job 
  'ST2CY5V39MWMZJQHQCP9TNAYZ1034H3E3NSP8AZKZ 
  u"Web Development Project" 
  u1000 
  (list 
    {description: "Design", payment: u400, completed: false}
    {description: "Implementation", payment: u600, completed: false}
  )
)

;; Freelancer completes first milestone
(complete-milestone u1 u0)

;; Client approves and pays milestone
(approve-milestone-payment u1 u0)
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (**git checkout -b feature/AmazingFeature**)
3. Commit your changes (**git commit -m 'Add some AmazingFeature'**)
4. Push to the branch (**git push origin feature/AmazingFeature**)
5. Open a Pull Request

## 📄 License

Distributed under the MIT License. See **License** for more information.

## 📞 Contact

Emmanuel Ifediora - @emma_ifedi

Project Link:
https://github.com/Manuelshub/BlockLance

## 🙏 Acknowledgements

- Stacks Blockchain
- Clarinet
- Open-Source Community