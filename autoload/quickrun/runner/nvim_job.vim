" quickrun: runner/nvim_job: Runs by Neovim job feature.
" Author : tamy0612 <tamura.yasumasa+github@gmail.com>
" License: zlib License

let s:is_win = g:quickrun#V.Prelude.is_windows()
let s:runner = {
\   'config': {
\     'pty': 0,
\   }
\ }

function! s:runner.validate() abort
  if !has('nvim')
    throw 'Needs Neovim to use runner/nvim_job.'
  endif
  if !s:is_win && !executable('sh')
    throw 'Needs "sh" on other than MS Windows.'
  endif
endfunction

function! s:runner.run(commands, input, session) abort
  let command = join(a:commands, ' && ')
  let cmd_arg = s:is_win ? printf('cmd.exe /c (%s)', command)
  \                      : ['sh', '-c', command]
  let options = {
        \ 'on_stdout': function(self.on_output, self),
        \ 'on_stderr': function(self.on_output, self),
        \ 'on_exit': function(self.on_exit, self),
        \}
  let options.pty = self.config.pty

  let self._key = a:session.continue()
  let self._job = jobstart(cmd_arg, options)
  if a:input !=# ''
    call chansend(self._job, a:input)
    call chanclose(self._job, 'stdin')
  endif
endfunction

function! s:runner.sweep() abort
  if has_key(self, '_job')
    while !has_key(self, '_job_exited')
      call jobstop(self._job)
    endwhile
  endif
endfunction

function! s:runner.on_output(job, data, event) abort
  call quickrun#session(self._key, 'output', join(a:data, "\n"))
endfunction

function! s:runner.on_exit(job, status, event) abort
  if !has_key(self, '_job_exited')
    let self._job_exited = a:status
  endif
  call quickrun#session(self._key, 'finish', self._job_exited)
endfunction

function! quickrun#runner#nvim_job#new() abort
  return deepcopy(s:runner)
endfunction
