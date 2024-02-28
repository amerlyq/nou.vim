# REF: https://pynvim.readthedocs.io/en/latest/usage/remote-plugins.html
# ALSO: +++ [_] NICE:READ:TRY: Writing and publishing a Python module in Rust ⌇⡡⡅⣿⢑
# USAGE: open .py file in insert, run :UpdateRemotePlugins, restart vim, :call NouFixClaimed()
import datetime as DT
import re
from pathlib import Path
from typing import Any

import pynvim
from just.flower.tenjo.lib.manipulate import entry_replace_spec


@pynvim.plugin
class TestPlugin:
    def __init__(self, nvim: pynvim.Nvim):
        self.nvim = nvim

    # DEBUG:  :echo NouLogAdvance(-1,1)
    # :<C-u>exe 'edit '. fnameescape(NouLogAdvance(1))<CR>
    @pynvim.function("NouLogAdvance", sync=True)
    def logadvance(self, args: Any) -> str | None:
        advance = args[0] if args else 0
        noedit = bool(args[1]) if len(args) > 1 else False
        p = Path(self.nvim.current.buffer.name)
        if p.is_symlink() and not re.match(r"(20\d\d)-(0\d|1[012])", p.name):
            p = p.resolve()
        Sdate = r"(20\d\d)-(0\d|1[012])-([012]\d|3[01])"
        if m := re.match(Sdate, p.name):
            year, month, day = map(int, m.groups())
            x = DT.date(year=year, month=month, day=day)
            x += DT.timedelta(days=advance)
            newnm = x.isoformat()
            # NOTE: search glob in same key/log
            d = p
            while (d := d.parent) not in (Path("."), Path("/")):
                if d.name in ("log", "key"):
                    fpath = next(d.rglob(newnm + "*"), None)
                    if fpath:
                        if noedit:
                            return str(fpath)
                        self.nvim.command("edit " + str(fpath))

        # TODO:ALSO: support weekly="2021-W32" files
        elif m := re.match(r"(20\d\d)-(0\d|1[012])", p.name):
            year, month = map(int, m.groups())
            year, month = divmod(year * 12 + month - 1 + advance, 12)
            month += 1
            fpath = next(p.parent.rglob(f"{year}-{month:02d}*"), None)
            if fpath:
                # self.nvim.command(f"echohl ErrorMsg | echom '{fpath}' | echohl None")
                if noedit:
                    return str(fpath)
                self.nvim.command("edit " + str(fpath))

        elif nums := re.findall("[0-9]+", p.name):
            nm, num = p.name, nums[-1]
            idx = nm.rfind(num)
            nm = nm[:idx] + str(int(num) + advance) + nm[idx + len(num) :]
            fpath = next(p.parent.rglob(nm), None)
            if fpath:
                if noedit:
                    return str(fpath)
                self.nvim.command("edit " + str(fpath))

    @pynvim.command("TestCmd", nargs="*", range="")
    def testcommand(self, args: Any, rng: Any) -> None:
        self.nvim.current.line = "Cmd with args: {}, range: {}".format(args, rng)

    # @pynvim.autocmd("BufEnter", pattern="*.py", eval='expand("<afile>")', sync=True)
    # def on_bufenter(self, filename):
    #     self.nvim.out_write("testplugin is in " + filename + "\n")

    # @pynvim.command("NouFixClaimed", nargs="*", range="")
    @pynvim.function("NouFixClaimed", sync=True)
    def fixclaimed(self, args: Any) -> tuple[int, int, int, str]:
        return self._entry_replace_spec("logtimediff", args[0])

    @pynvim.function("NouSumHierarchy", sync=True)
    def sumhierarchy(self, _args: Any) -> tuple[int, int, int, str]:
        return self._entry_replace_spec("sumtaskhier")

    @pynvim.function("NouSumLogBlock", sync=True)
    def sumlogblock(self, _args: Any) -> tuple[int, int, int, str]:
        return self._entry_replace_spec("sumlogblock")

    def _entry_replace_spec(self, val: str, param: int = 0) -> tuple[int, int, int, str]:
        buf = self.nvim.current.buffer
        path = buf.name
        row, col = self.nvim.current.window.cursor
        try:
            (_fpth, lnum, col, nchr, txt) = entry_replace_spec(
                loci=f"{path}:{row}:{col}",
                xkey="span.val.claimed",
                val=val,
                lines=buf[:],
                param=param,
            )
        except ValueError as exc:
            self.nvim.command(f"echohl ErrorMsg | echom '{exc}' | echohl None")
            return

        # FIXME: .col is unicode char, not byte offset
        # strlen(strcharpart(a:s, strchars(a:s) - 1, 1))
        # assert str(fpth) == buf.name
        # ERR: TypeError: 'str' object does not support item assignment
        # buf[lnum][col : col + nchr] = txt
        l = buf[lnum - 1]
        # BAD: replaces whole line instead of doing small edit
        buf[lnum - 1] = l[: col - 1] + txt + " " + l[col - 1 + nchr :].lstrip()
        return (lnum, col, nchr, txt)
