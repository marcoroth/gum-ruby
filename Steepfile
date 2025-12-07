# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature "sig"

  check "lib"

  library "open3"
  library "tempfile"

  configure_code_diagnostics(D::Ruby.lenient)
end
