add-auto-load-safe-path /root/.gdbinit
source ~/.gdbinit_pwndbg
set debuginfod enabled on
source /opt/splitmind/gdbinit.py
python
import splitmind
(splitmind.Mind()
  .right(of="main", display="disasm", size="60%")
  .below(of="main", display="backtrace", size="25%")
  .below(of="disasm", display="regs", size="55%")
  .show("legend", on="disasm")
).build()
end
#source ~/.gdbinit-gef.py
# Set context sections to appear at each step
set context-sections regs disasm backtrace code
source /opt/ret-sync/ext_gdb/sync.py
