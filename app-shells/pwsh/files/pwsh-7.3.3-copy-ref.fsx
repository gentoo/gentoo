// Copyright 1999-2023 Gentoo Authors
// Distributed under the terms of the GNU General Public License v2


open System.IO
open System.Runtime.InteropServices


let args =
    fsi.CommandLineArgs |> Array.tail


let wanted_directory =
    System.IO.Path.GetFullPath args.[0]

printfn $" * Wanted directory: {wanted_directory}"

System.IO.Directory.CreateDirectory wanted_directory


let runtime_directory =
    RuntimeEnvironment.GetRuntimeDirectory ()

printfn $" * Runtime directory: {runtime_directory}"


let runtime_files =
    System.IO.Directory.GetFiles runtime_directory
    |> Array.filter (fun s -> s.EndsWith ".dll")
    |> Array.sort

printfn $" * Copying {runtime_files.Length} files"


for runtime_file in runtime_files do
    let runtime_file_name =
        System.IO.Path.GetFileName runtime_file

    let wanted_runtime_file =
        System.IO.Path.Join(wanted_directory, runtime_file_name)

    FileInfo(runtime_file).CopyTo(wanted_runtime_file, true)
    |> ignore
