####################################################################################
##               ,:                                                         ,:    ##
##             ,' |                                                       ,' |    ##
##            /   :                                                      /   :    ##
##         --'   /       :::::::::::   :::::::::::   :::    :::       --'   /     ##
##         \/ />/           :+:            :+:       :+:   :+:        \/ />/      ##
##         / /_\           +:+            +:+       +:+  +:+          / /_\       ##
##      __/   /           +#+            +#+       +#++:++         __/   /        ##
##      )'-. /           +#+            +#+       +#+  +#+         )'-. /         ##
##      ./  :\          #+#        #+# #+#       #+#   #+#         ./  :\         ##
##       /.' '         ###         #####        ###    ###          /.' '         ##
##     '/'                                                        '/'             ##
##     +                                                          +               ##
##    '                                                          '                ##
####################################################################################
##            Copyright © 2023 Tyler J. Kenney. All rights reserved.              ##
####################################################################################
####################################################################################

## NOTICE: DO NOT EDIT!!
## NOTICE: This file was autogenerated by gen-mod-pipelines.py
## NOTICE: DO NOT EDIT!!


## Sub-Pipeline: tf_to_mo
export tf_to_mo="builtin.module(
tf-to-mo{ prune-assert-ops=true use-mo-ops=true}
)"


## Sub-Pipeline: monnx_lowering
export monnx_lowering="builtin.module(
monnx-upversioning,
monnx-shape-inference,
monnx-inliner,
monnx-rewriter,
monnx-to-mo{},
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
mo.graph(name-input-dims{})
)"


## Sub-Pipeline: shape_inference
export shape_inference="builtin.module(
resolve-unknown-parameters{resolveRMOOnly=true},
legalize-rmo-operators{skip-rmo-rebinds=false},
cse,
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
mo.graph(lower-qdq-operators-to-mo{lower-computational-ops=true}),
mo.graph(fixup-moq-operator-dtypes),
mo.graph(simplify-qdq-patterns),
mo.graph(legalize-moq-operators-to-mo),
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
cse,
constant-fold{iterations=2},
resolve-unknown-parameters{resolveRMOOnly=false},
mo.graph(add-fallback-shape-funcs{ restricted=true}),
mo.graph(symbolicize-fallback-shape-funcs{}),
materialize-shape-funcs,
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
staticize-shapes,
mo.graph(symbolicize-fallback-shape-funcs{}),
inline-shape-funcs,
cse,
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
symbol-dce,
mo.graph(propagate-shapes),
cse,
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
mo.graph(symbolic-optimize{symbolic-ffast-math=true symbolic-no-undefined-math=true}),
mo.graph(propagate-shapes),
mo.graph(add-fallback-shape-funcs{ restricted=false}),
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
cse,
mo.graph(symbolic-optimize{symbolic-ffast-math=true symbolic-no-undefined-math=true}),
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
cse,
constant-fold{iterations=2},
mo.graph(add-devices{default-device-label= enable-extra-devices=false enable-fake-cuda-device=false})
)"


## Sub-Pipeline: mo_to_mogg
export mo_to_mogg="builtin.module(
mo.graph(infer-layouts),
mo.graph(mo-pattern-fusion{mha-allow-internal-reshape=true mha-allow-unsafe-bcast=true mha-debug=false mha-enable=true}),
mo.graph(symbolicize-fallback-shape-funcs{}),
mo.graph(propagate-shapes),
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
cse,
mo.graph(assign-devices{small-tensor-limit=1024}),
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
cse,
constant-fold{iterations=2},
mo.graph(hoist-param-exprs),
mo-to-mogg{},
mo.graph(simplify-kernel-operands),
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
cse
)"


## Sub-Pipeline: mo_fusion
export mo_fusion="builtin.module(
mo.graph(fuse-elementwise{dump-dot-graph=false}),
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
cse,
mo.graph(simplify-kernel-operands),
mo.graph(fuse-bcasts),
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
cse,
mo.graph(simplify-kernel-operands),
mo.graph(fuse-in-out-lambdas),
cse,
mo.graph(simplify-kernel-operands),
mo.graph(mark-trivial-kernels),
mo.graph(inline-lambdas),
mo.graph(soft-fuse{non-host-kernel-limit=3 small-tensor-limit=1024}),
sequence-fuse-kernels{heuristic=conservative  non-host-kernel-limit=3},
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
cse,
mo.graph(fuse-consts),
mo.graph(stack-allocate-temporaries{small-tensor-limit=5000}),
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
cse,
mo.graph(simplify-kernel-operands)
)"


## Sub-Pipeline: mogg_to_mgp
export mogg_to_mgp="builtin.module(
jit-compile-kernels{create-mogg-reproducers=false dump-stub=false  min-cpu-alignment=64 save-temp-prefix= split-binary-compile=false time-mogg-compile=false use-search=false},
mo-to-primitives{compiled-framework-label=mof min-cpu-alignment=64},
cse,
remove-redundant-tensor-extracts,
mgp.model(simplify-chains),
mgp.model(concat-in-place),
mgp.model(defer-tensor-create-exec),
mgp.model(defer-allocs),
mgp.model(exec-invariant-code-motion),
mgp.model(verify-model-arguments),
mgp.model(predicate-asserts-deps),
mgp.model(strip-buffer-attributes),
canonicalize{  max-iterations=10 max-num-rewrites=-1 region-simplify=true test-convergence=false top-down=true},
cse,
mgp.model(fixup-overhangs),
mgp.model(simplify-chains),
cse
)"
