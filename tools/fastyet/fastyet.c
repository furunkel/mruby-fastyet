#include <stdio.h>
#include <stdlib.h>
#include "mruby.h"
#include "mruby/compile.h"
#include "mruby/array.h"

int
main(int argc, char *argv[])
{
  mrb_state *mrb;
  int i;
  mrb_value ARGV;

  mrb = mrb_open();
  ARGV = mrb_ary_new_capa(mrb, argc - 1);
  for (i = 1; i < argc; i++) {
    mrb_ary_push(mrb, ARGV, mrb_str_new_cstr(mrb, argv[i]));
  }
  mrb_define_global_const(mrb, "ARGV", ARGV);

  mrb_load_string(mrb, "Fastyet.start");

  if(mrb->exc) {
    mrb_p(mrb, mrb_obj_value(mrb->exc));
  }

  mrb_close(mrb);

  return EXIT_SUCCESS;
}
