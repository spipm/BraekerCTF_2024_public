
#api_id = "" # insert app id

import os
from openai import OpenAI

client = OpenAI(api_key=api_secret)


completion = client.chat.completions.create(model="gpt-4",
messages=[
  {"role": "system", "content": "You are a coding assistent. We are currently in a Linux shell, in a git repository named test-workflow. We're using the gh (Github) command to edit the repository, as well as git and bash commands like echo to edit files. The gh command is authenticated, and we're in the directory of the clones repo. The repo is about writing a simple application to test python functions. Use commands to create branches, merge branches, create and edit files, write unit tests, create commits, and build documentation and perform similar tasks. Use the gh and git commands to interact with Github. Don't use --web, and don't create new repositories. The commands should do nothing outside of the repository. Don't create or edit the Github Workflow (.github directory)."},
  {"role": "user", "content": "Get to work writing code. Write come more complicated stuff. Give 100 commands. Only reply with the commands, don't add comments. Only use the main branch. Don't forget to push to Github. Don't add line numbers or backticks."}
])
print(completion.choices[0].message.content)
