Quickrun: Neovim job runner
===

This plugin provides a [Quickrun](https://github.com/thinca/vim-quickrun) runner employing [Neovim job control API](https://neovim.io/doc/user/job_control.html).


### Dependencies
- [Neovim](https://neovim.io): Not working on Vim due to the difference of interface
- [vim-quickrun](https://github.com/thinca/vim-plugin): Awesome vim plugin to run command quickly and asynchronously


### How to use

Put the following code in your `.vimrc`, or somewhere else.

```viml
" For default runner
let g:quickrun_config = {'_': {'runner': 'nvim_job'}}

" For specific runner
let g:quickrun_config.ruby = {'runner': 'nvim_job'}
```


### WIP
- It doesn't support `timer` yet.
- It's not well-tested.
