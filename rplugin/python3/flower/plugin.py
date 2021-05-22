import pynvim


@pynvim.plugin
class Plugin:
    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.function("TestFunction", sync=True)
    def testfunction(self, args):
        return 3

    @pynvim.command("TestCommand", nargs="*", range="")
    def testcommand(self, args, rng):
        self.nvim.current.line = "Command with args: {}, range: {}".format(args, rng)

    @pynvim.autocmd("BufEnter", pattern="*.py", eval='expand("<afile>")', sync=True)
    def on_bufenter(self, filename):
        self.nvim.out_write("testplugin is in " + filename + "\n")
