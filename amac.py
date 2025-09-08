new="??"

cmd.fab(new)

cmd.edit("%/C")

cmd.attach("O",2,2)

cmd.alter('1/N', 'formal_charge=1')

cmd.edit("1/N")

cmd.h_fill()

cmd.alter('all', 'chain="X"')

cmd.sculpt_activate('all')

cmd.sculpt_iterate('all', cycles=5000)

cmd.sculpt_deactivate('all')

cmd.save(new+".pdb")

cmd.quit()
