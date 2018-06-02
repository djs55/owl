(*
 * OWL - an OCaml numerical library for scientific computing
 * Copyright (c) 2016-2018 Liang Wang <liang.wang@cl.cam.ac.uk>
 *)

open Bigarray

open Owl_types

open Owl_graph


(* Functor of making a Lazy engine to execute a computation graph. *)

module Make (A : Ndarray_Algodiff) = struct

  include Owl_computation_graph.Make (A)


  let rec _optimise_term x =
    Owl_log.debug "optimise %s ..." (node_to_str x);
    if is_valid x = false then (
      (
        match (get_operator x) with
        | Noop                                        -> pattern_003 x
        | Var                                         -> ()
        | Const                                       -> pattern_000 x
        | Empty shape                                 -> pattern_000 x
        | Zeros shape                                 -> pattern_000 x
        | Ones shape                                  -> pattern_000 x
        | Create                                      -> pattern_000 x
        | Sequential                                  -> pattern_000 x
        | Uniform shape                               -> pattern_000 x
        | Gaussian                                    -> pattern_000 x
        | Bernoulli (p, shape)                        -> pattern_000 x
        | Init _                                      -> pattern_000 x
        | Get i                                       -> pattern_000 x
        | Set i                                       -> pattern_000 x
        | GetSlice slice                              -> pattern_000 x
        | SetSlice slice                              -> pattern_000 x
        | Copy                                        -> pattern_000 x
        | Reset                                       -> pattern_000 x
        | Reshape shape                               -> pattern_000 x
        | Reverse                                     -> pattern_000 x
        | Tile repeats                                -> pattern_000 x
        | Repeat (axis, repeats)                      -> pattern_000 x
        | Concatenate axis                            -> pattern_000 x
        | Split (axis, parts)                         -> pattern_000 x
        | Draw (axis, n)                              -> pattern_000 x
        | Map f                                       -> pattern_000 x
        | Fold (axis, f)                              -> pattern_000 x
        | Scan (axis, f)                              -> pattern_000 x
        | OneHot depth                                -> pattern_000 x
        | Abs                                         -> pattern_000 x
        | Neg                                         -> pattern_000 x
        | Floor                                       -> pattern_000 x
        | Ceil                                        -> pattern_000 x
        | Round                                       -> pattern_000 x
        | Sqr                                         -> pattern_000 x
        | Sqrt                                        -> pattern_000 x
        | Log                                         -> pattern_000 x
        | Log2                                        -> pattern_000 x
        | Log10                                       -> pattern_000 x
        | Exp                                         -> pattern_000 x
        | Sin                                         -> pattern_000 x
        | Cos                                         -> pattern_000 x
        | Tan                                         -> pattern_000 x
        | Sinh                                        -> pattern_000 x
        | Cosh                                        -> pattern_000 x
        | Tanh                                        -> pattern_000 x
        | Asin                                        -> pattern_000 x
        | Acos                                        -> pattern_000 x
        | Atan                                        -> pattern_000 x
        | Asinh                                       -> pattern_000 x
        | Acosh                                       -> pattern_000 x
        | Atanh                                       -> pattern_000 x
        | Min axis                                    -> pattern_000 x
        | Max axis                                    -> pattern_000 x
        | Sum axis                                    -> pattern_000 x
        | SumReduce axis                              -> pattern_000 x
        | Signum                                      -> pattern_000 x
        | Sigmoid                                     -> pattern_000 x
        | Relu                                        -> pattern_000 x
        | Min'                                        -> pattern_000 x
        | Max'                                        -> pattern_000 x
        | Sum'                                        -> pattern_000 x
        | L1norm'                                     -> pattern_000 x
        | L2norm'                                     -> pattern_000 x
        | L2NormSqr'                                  -> pattern_000 x
        | ClipByValue                                 -> pattern_000 x
        | ClipByL2norm                                -> pattern_000 x
        | Pow                                         -> pattern_000 x
        | ScalarPow                                   -> pattern_000 x
        | PowScalar                                   -> pattern_000 x
        | Atan2                                       -> pattern_000 x
        | ScalarAtan2                                 -> pattern_000 x
        | Atan2Scalar                                 -> pattern_000 x
        | Add                                         -> pattern_001 x
        | Sub                                         -> pattern_000 x
        | Mul                                         -> pattern_000 x
        | Div                                         -> pattern_007 x
        | AddScalar                                   -> pattern_000 x
        | SubScalar                                   -> pattern_000 x
        | MulScalar                                   -> pattern_000 x
        | DivScalar                                   -> pattern_000 x
        | ScalarAdd                                   -> pattern_000 x
        | ScalarSub                                   -> pattern_000 x
        | ScalarMul                                   -> pattern_000 x
        | ScalarDiv                                   -> pattern_000 x
        | IsZero                                      -> pattern_000 x
        | IsPositive                                  -> pattern_000 x
        | IsNegative                                  -> pattern_000 x
        | IsNonpositive                               -> pattern_000 x
        | IsNonnegative                               -> pattern_000 x
        | Equal                                       -> pattern_000 x
        | NotEqual                                    -> pattern_000 x
        | Less                                        -> pattern_000 x
        | Greater                                     -> pattern_000 x
        | LessEqual                                   -> pattern_000 x
        | GreaterEqual                                -> pattern_000 x
        | EltEqual                                    -> pattern_000 x
        | EltNotEqual                                 -> pattern_000 x
        | EltLess                                     -> pattern_000 x
        | EltGreater                                  -> pattern_000 x
        | EltLessEqual                                -> pattern_000 x
        | EltGreaterEqual                             -> pattern_000 x
        | EltEqualScalar                              -> pattern_000 x
        | EltNotEqualScalar                           -> pattern_000 x
        | EltLessScalar                               -> pattern_000 x
        | EltGreaterScalar                            -> pattern_000 x
        | EltLessEqualScalar                          -> pattern_000 x
        | EltGreaterEqualScalar                       -> pattern_000 x
        | ApproxEqual eps                             -> pattern_000 x
        | ApproxEqualScalar eps                       -> pattern_000 x
        | ApproxEltEqual eps                          -> pattern_000 x
        | ApproxEltEqualScalar eps                    -> pattern_000 x
        | Conv1d (padding, stride)                    -> pattern_000 x
        | Conv2d (padding, stride)                    -> pattern_000 x
        | Conv3d (padding, stride)                    -> pattern_000 x
        | TransposeConv2d (padding, stride)           -> pattern_000 x
        | MaxPool1d (padding, kernel, stride)         -> pattern_000 x
        | MaxPool2d (padding, kernel, stride)         -> pattern_000 x
        | MaxPool3d (padding, kernel, stride)         -> pattern_000 x
        | AvgPool1d (padding, kernel, stride)         -> pattern_000 x
        | AvgPool2d (padding, kernel, stride)         -> pattern_000 x
        | AvgPool3d (padding, kernel, stride)         -> pattern_000 x
        | Conv1dBackwardInput stride                  -> pattern_000 x
        | Conv1dBackwardKernel stride                 -> pattern_000 x
        | Conv2dBackwardInput stride                  -> pattern_000 x
        | Conv2dBackwardKernel stride                 -> pattern_000 x
        | Conv3dBackwardInput stride                  -> pattern_000 x
        | Conv3dBackwardKernel stride                 -> pattern_000 x
        | TransposeConv2dBackwardInput stride         -> pattern_000 x
        | TransposeConv2dBackwardKernel stride        -> pattern_000 x
        | MaxPool1dBackward (padding, kernel, stride) -> pattern_000 x
        | MaxPool2dBackward (padding, kernel, stride) -> pattern_000 x
        | MaxPool3dBackward (padding, kernel, stride) -> pattern_000 x
        | AvgPool1dBackward (padding, kernel, stride) -> pattern_000 x
        | AvgPool2dBackward (padding, kernel, stride) -> pattern_000 x
        | AvgPool3dBackward (padding, kernel, stride) -> pattern_000 x
        | Row                                         -> pattern_000 x
        | Rows i                                      -> pattern_000 x
        | CopyRowTo                                   -> pattern_000 x
        | CopyColTo                                   -> pattern_000 x
        | Dot (transa, transb, alpha, beta)           -> pattern_005 x
        | Inv                                         -> pattern_000 x
        | Trace                                       -> pattern_000 x
        | Transpose axis                              -> pattern_000 x
        | ToRows                                      -> pattern_000 x
        | OfRows                                      -> pattern_000 x
        | OfArray shape                               -> pattern_000 x
        | OfArrays                                    -> pattern_000 x
        | Scalar_Add                                  -> pattern_000 x
        | Scalar_Sub                                  -> pattern_000 x
        | Scalar_Mul                                  -> pattern_000 x
        | Scalar_Div                                  -> pattern_000 x
        | Scalar_Pow                                  -> pattern_000 x
        | Scalar_Atan2                                -> pattern_000 x
        | Scalar_Abs                                  -> pattern_000 x
        | Scalar_Neg                                  -> pattern_000 x
        | Scalar_Sqr                                  -> pattern_000 x
        | Scalar_Sqrt                                 -> pattern_000 x
        | Scalar_Exp                                  -> pattern_000 x
        | Scalar_Log                                  -> pattern_000 x
        | Scalar_Log2                                 -> pattern_000 x
        | Scalar_Log10                                -> pattern_000 x
        | Scalar_Signum                               -> pattern_000 x
        | Scalar_Floor                                -> pattern_000 x
        | Scalar_Ceil                                 -> pattern_000 x
        | Scalar_Round                                -> pattern_000 x
        | Scalar_Sin                                  -> pattern_000 x
        | Scalar_Cos                                  -> pattern_000 x
        | Scalar_Tan                                  -> pattern_000 x
        | Scalar_Sinh                                 -> pattern_000 x
        | Scalar_Cosh                                 -> pattern_000 x
        | Scalar_Tanh                                 -> pattern_000 x
        | Scalar_Asin                                 -> pattern_000 x
        | Scalar_Acos                                 -> pattern_000 x
        | Scalar_Atan                                 -> pattern_000 x
        | Scalar_Asinh                                -> pattern_000 x
        | Scalar_Acosh                                -> pattern_000 x
        | Scalar_Atanh                                -> pattern_000 x
        | Scalar_Relu                                 -> pattern_000 x
        | Scalar_Sigmoid                              -> pattern_000 x
        | _                                           -> failwith "Owl_computation_optimiser:_optimise_term"
      );
      validate x
    )


  (* dummy pattern *)
  and pattern_000 x =
    let parents = parents x in
    Array.iter _optimise_term parents


  (* add ndarray pattern *)
  and pattern_001 x =
    Owl_log.debug "pattern_001";
    let parents = parents x in
    let a = parents.(0) in
    let b = parents.(1) in
    _optimise_term a;
    _optimise_term b;
    pattern_002 x;
    pattern_004 x


  (* add ndarray pattern: add ndarray a zero *)
  and pattern_002 x =
    Owl_log.debug "pattern_002";
    let x_parents = parents x in
    let a = x_parents.(0) in
    let b = x_parents.(1) in
    if get_operator x = Add then (
      (
        match get_operator a with
        | Zeros shape -> (
            set_operator x Noop;
            remove_edge a x;
            let value = get_value x in
            if Array.length value > 0 then
              set_value x [|value.(1)|];
            _optimise_term x
          )
        | _           -> ()
      );
      (
        match get_operator b with
        | Zeros shape -> (
            set_operator x Noop;
            remove_edge b x;
            let value = get_value x in
            if Array.length value > 0 then
              set_value x [|value.(0)|];
            _optimise_term x
          )
        | _           -> ()
      )
    )


  (* noop pattern *)
  and pattern_003 x =
    Owl_log.debug "pattern_003";
    let parent = (parents x).(0) in
    _optimise_term parent;
    let op = get_operator x in
    let is_leaf = outdegree x = 0 in
    if op = Noop && is_leaf = false then (
      set_children parent (children x);
      replace_parent x parent;
      remove_node x
    )


  (* add ndarray pattern: FMA pattern *)
  and pattern_004 x =
    Owl_log.debug "pattern_004";
    if get_operator x = Add then (
      let x_parents = parents x in
      let a = x_parents.(0) in
      let b = x_parents.(1) in
      if get_operator a = Mul && refnum a = 1 then (
        let new_parents = Owl_utils_array.((parents a) @ [|b|]) in
        set_parents x new_parents;
        replace_child a x;
        set_operator x FMA;
        remove_node a;
      )
      else if get_operator b = Mul && refnum b = 1 then (
        let new_parents = Owl_utils_array.((parents b) @ [|a|]) in
        set_parents x new_parents;
        replace_child b x;
        set_operator x FMA;
        remove_node b;
      )
    )


  (* gemm pattern *)
  and pattern_005 x =
    Owl_log.debug "pattern_005";
    let x_parents = parents x in
    let a = x_parents.(0) in
    let b = x_parents.(1) in
    _optimise_term a;
    _optimise_term b;
    pattern_006 x


  (* gemm pattern: transpose *)
  and pattern_006 x =
    Owl_log.debug "pattern_006";
    match get_operator x with
    | Dot (transa, transb, alpha, beta) -> (
        let x_parents = parents x in
        let a = x_parents.(0) in
        let b = x_parents.(1) in
        (
          match get_operator a with
          | Transpose i -> (
              if refnum a = 1 then (
                let op = Dot (not transa, transb, alpha, beta) in
                set_operator x op;
                let a_parent = (parents a).(0) in
                replace_child a x;
                replace_parent a a_parent;
              )
            )
          | _           -> ()
        );
        (
          match get_operator b with
          | Transpose i -> (
              if refnum b = 1 then (
                let op = Dot (transa, not transb, alpha, beta) in
                set_operator x op;
                let b_parent = (parents b).(0) in
                replace_child b x;
                replace_parent b b_parent;
              )
            )
          | _           -> ()
        );
      )
    | _                                 -> ()


  (* div pattern *)
  and pattern_007 x =
    Owl_log.debug "pattern_007";
    let x_parents = parents x in
    let a = x_parents.(0) in
    let b = x_parents.(1) in
    _optimise_term a;
    _optimise_term b;
    pattern_008 x


  (* div pattern: zero divided by x *)
  and pattern_008 x =
    Owl_log.debug "pattern_008";
    if get_operator x = Div then (
      let x_parents = parents x in
      let a = x_parents.(0) in
      let b = x_parents.(1) in
      let x_shp = shape (node_to_arr x) in
      match get_operator a with
      | Zeros _ -> (
          remove_edge a x;
          remove_edge b x;
          set_operator x (Zeros x_shp)
        )
      | _       -> ()
    )


  (* div pattern: x divided by one *)
  and pattern_009 x =
    Owl_log.debug "pattern_009";
    if get_operator x = Div then (
      let x_parents = parents x in
      let b = x_parents.(1) in
      let x_shp = shape (node_to_arr x) in
      match get_operator b with
      | Ones b_shp -> (
          if x_shp = b_shp then (
            remove_edge b x;
            set_operator x Noop;
            _optimise_term x
          )
        )
      | _       -> ()
    )


  let run x =
    Array.iter _optimise_term (Obj.magic x);
    (* NOTE: invalidate ancestors *)
    iter_ancestors (fun v -> invalidate v) (Obj.magic x)


end

(* Make functor ends *)
