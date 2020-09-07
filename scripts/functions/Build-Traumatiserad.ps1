  function Build-Traumatiserad {
      param (
      [Parameter(Mandatory)]
      [string]$RootPath
      )

      npm --prefix $RootPath run build
  }