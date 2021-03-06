#include <stdio.h>
#include <time.h>
#include "mruby.h"
#include "mruby/array.h"
#include "mruby/compile.h"

static mrb_value
fastyet_run(mrb_state *mrb, mrb_value self)
{
  char *filename;
  int argc, i;
  int filename_len;
  mrb_value *argv;
  FILE *file;
  mrb_state *run_mrb;
  mrb_value ARGV;
  mrb_value result;
  clock_t c1, c2;
  mrb_value retval;
  double secs;
  int flags = 0;

  mrb_get_args(mrb, "si*", &filename, &filename_len, &flags, &argv, &argc);

  file = fopen(filename, "r");
  if (!file) {
    mrb_raisef(mrb, E_RUNTIME_ERROR, "cannot open %S",
                   mrb_str_new(mrb, filename, filename_len));
  }

  run_mrb = mrb_open();
  ARGV = mrb_ary_new_capa(run_mrb, argc);
  for (i = 0; i < argc; i++) {
    mrb_ary_push(run_mrb, ARGV, argv[i]);
  }
  mrb_define_global_const(run_mrb, "ARGV", ARGV);

#ifdef MRB_ENABLE_JIT
  run_mrb->run_flags = flags;
#endif

  c1 = clock();
  result = mrb_load_file(run_mrb,  file);
  c2 = clock();

  fclose(file);

  if (mrb->exc) {
    mrb_raise(mrb, E_RUNTIME_ERROR, "benchmark failed");
  }

  mrb_close(run_mrb);

  secs = ((double)(c2 - c1)) / CLOCKS_PER_SEC;
  retval = mrb_ary_new(mrb);
  mrb_ary_push(mrb, retval, result);
  mrb_ary_push(mrb, retval, mrb_float_value(mrb, secs));

  return retval;
}

#ifndef MRB_ENABLE_JIT
#define MRB_RUN_NORMAL 0
#define MRB_RUN_JIT 0
#endif

void
mrb_mruby_fastyet_gem_init(mrb_state* mrb)
{
  struct RClass *c;
  c = mrb_define_module(mrb, "Fastyet");
  mrb_define_class_method(mrb, c, "run", fastyet_run, MRB_ARGS_REQ(1));
  mrb_define_const(mrb, c, "RUN_NORMAL", mrb_fixnum_value(MRB_RUN_NORMAL));
  mrb_define_const(mrb, c, "RUN_JIT", mrb_fixnum_value(MRB_RUN_JIT));
}


void
mrb_mruby_fastyet_gem_final(mrb_state* mrb)
{
}
