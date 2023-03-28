# haiku

Haiku (chat-gpt powered) plugin for oh-my-zsh

An Oh My Zsh plugin that prints a haiku promoting work-life balance and stress management once every 24 hours if your terminal has been open for more than 3 hours


## Example

```
alesr in ~ λ

Work hard, play hard
Take care of yourself
Have a great life!
alesr in ~ λ

Work life balance,
A must for clear thoughts:
Rest and be kind.
alesr in ~ λ

Refreshing moments bring;
Some much needed balance, now;
Leave desk, go outside.
alesr in ~ λ

Take a break!
Calm your mind, your soul!
Self-care is key!
alesr in ~ λ

Work-life balance?
Must find a way to de-stress;
Take a break, have cake.
alesr in ~ λ
```

## Requirements

- [OpenAI API key](https://platform.openai.com/account/api-keys) set in the environment variable `OPENAI_API_KEY`
- curl or wget
- jq
## Installation

### Manual

Clone this repository into your oh-my-zsh custom plugins directory:

```sh
git clone https://github.com/alesr/haiku.git
```

Add the plugin to the list of plugins for Oh My Zsh to load (inside ~/.zshrc):

```sh
plugins=(... haiku)
```

````sh
source ~/.zshrc
````
