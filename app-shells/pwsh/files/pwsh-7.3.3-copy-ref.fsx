// Copyright 1999-2024 Gentoo Authors
// Distributed under the terms of the GNU General Public License v2

open System.IO
open System.Runtime.InteropServices

let args = fsi.CommandLineArgs |> Array.tail

let wantedDirectory = System.IO.Path.GetFullPath args.[0]

printfn $" * Wanted directory: {wantedDirectory}"

System.IO.Directory.CreateDirectory wantedDirectory

let runtimeDirectory = RuntimeEnvironment.GetRuntimeDirectory()

printfn $" * Runtime directory: {runtimeDirectory}"

let runtimeFiles =
    System.IO.Directory.GetFiles runtimeDirectory
    |> Array.filter (fun s -> s.EndsWith ".dll")
    |> Array.sort

printfn $" * Copying {runtimeFiles.Length} files into {wantedDirectory}"

for runtime_file in runtimeFiles do
    let runtimeFileName = System.IO.Path.GetFileName runtime_file
    let wantedRuntimeFile = System.IO.Path.Join(wantedDirectory, runtimeFileName)

    FileInfo(runtime_file).CopyTo(wantedRuntimeFile, true) |> ignore
