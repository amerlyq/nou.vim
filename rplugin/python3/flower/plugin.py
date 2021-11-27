# REF: https://pynvim.readthedocs.io/en/latest/usage/remote-plugins.html
# ALSO: +++ [_] NICE:READ:TRY: Writing and publishing a Python module in Rust ⌇⡡⡅⣿⢑
# USAGE: open .py file in insert, run :UpdateRemotePlugins, restart vim, :call NouFixClaimed()
import pynvim
from just.flower.tenjo.manipulate import entry_replace_spec


@pynvim.plugin
class TestPlugin:
    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.function("TestFunction", sync=True)
    def testfunction(self, _args):
        return 3

    @pynvim.command("TestCmd", nargs="*", range="")
    def testcommand(self, args, rng):
        self.nvim.current.line = "Cmd with args: {}, range: {}".format(args, rng)

    # @pynvim.autocmd("BufEnter", pattern="*.py", eval='expand("<afile>")', sync=True)
    # def on_bufenter(self, filename):
    #     self.nvim.out_write("testplugin is in " + filename + "\n")

    # @pynvim.command("NouFixClaimed", nargs="*", range="")
    @pynvim.function("NouFixClaimed", sync=True)
    def fixclaimed(self, _args):
        buf = self.nvim.current.buffer
        path = buf.name
        row, col = self.nvim.current.window.cursor
        (_fpth, lnum, col, nchr, txt) = entry_replace_spec(
            loci=f"{path}:{row}:{col}",
            xkey="span.val.claimed",
            val=".",
            lines=buf[:],
        )
        # FIXME: .col is unicode char, not byte offset
        # strlen(strcharpart(a:s, strchars(a:s) - 1, 1))
        # assert str(fpth) == buf.name
        # ERR: TypeError: 'str' object does not support item assignment
        # buf[lnum][col : col + nchr] = txt
        l = buf[lnum - 1]
        # BAD: replaces whole line instead of doing small edit
        buf[lnum - 1] = l[: col - 1] + txt + " " + l[col - 1 + nchr :].lstrip()
        return (lnum, col, nchr, txt)
