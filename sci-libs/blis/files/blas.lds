{
  # Export BLAS symbols
  global:
    *_;
    RowMajorStrg;

  # Hide everything else.
  local:
    cblas_*;
    CBLAS_*;
    bli_thread_set_num_threads_;
    bli_thread_set_ways_;
    bli_*;
    *;
};
