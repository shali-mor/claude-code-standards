// Commitlint configuration for Forcepoint repositories
// Enforces: <JIRA-TICKET> <Summary in imperative mood>
// Example: NEO-1234 Fix policy evaluation timeout

module.exports = {
  plugins: [
    {
      rules: {
        'jira-ticket-prefix': ({ header }) => {
          const jiraPattern = /^[A-Z]{2,}-\d+\s.+/;
          return [
            jiraPattern.test(header),
            'Commit message must start with a Jira ticket (e.g., NEO-1234 Fix policy timeout)',
          ];
        },
      },
    },
  ],
  rules: {
    'type-enum': [0],
    'type-empty': [0],
    'subject-empty': [2, 'never'],
    'header-max-length': [2, 'always', 72],
    'jira-ticket-prefix': [2, 'always'],
  },
};
