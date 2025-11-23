#!/usr/bin/env bash
# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

source tests-common.sh || exit
# TODO: hack because tests-common don't implement ver_cut
source version-funcs.sh || exit

inherit dist-kernel-utils

test_PV_to_KV() {
	local kv=${1}
	local exp_PV=${2}

	tbegin "dist-kernel_PV_to_KV ${kv} -> ${exp_PV}"
	local val=$(dist-kernel_PV_to_KV "${kv}")
	[[ ${val} == ${exp_PV} ]]
	tend $?
}

test_compressed_module_cleanup() {
	mkdir -p "${tmpdir}/source" || die
	pushd "${tmpdir}" >/dev/null || die

	local module option fail=0
	for option in NONE GZIP XZ ZSTD; do
		tbegin "CONFIG_MODULE_COMPRESS_${option}"
		echo "CONFIG_MODULE_COMPRESS_${option}=y" > source/.config

		touch a.ko b.ko.gz c.ko.xz d.ko.gz e.ko f.ko.xz || die
		# ensure some files are older
		touch -d "2 hours ago" d.ko e.ko.xz f.ko.gz || die

		IUSE=modules-compress dist-kernel_compressed_module_cleanup .

		local to_keep=( a.ko b.ko.gz c.ko.xz )
		local to_remove=()

		case ${option} in
			NONE)
				to_keep+=( d.ko e.ko f.ko.xz )
				to_remove+=( d.ko.gz e.ko.xz f.ko.gz )
				;;
			GZIP)
				to_keep+=( d.ko.gz e.ko f.ko.gz )
				to_remove+=( d.ko e.ko.xz f.ko.xz )
				;;
			XZ)
				to_keep+=( d.ko.gz e.ko.xz f.ko.xz )
				to_remove+=( d.ko e.ko f.ko.gz )
				;;
			ZSTD)
				to_keep+=( d.ko.gz e.ko f.ko.xz )
				to_remove+=( d.ko e.ko.xz f.ko.gz )
				;;
		esac

		for module in "${to_keep[@]}"; do
			if [[ ! -f ${module} ]]; then
				eerror "Module ${module} was removed"
				fail=1
			fi
		done

		for module in "${to_remove[@]}"; do
			if [[ -f ${module} ]]; then
				eerror "Module ${module} was not removed"
				fail=1
			fi
		done
		tend ${fail}
	done

	popd >/dev/null || die
}


test_PV_to_KV 6.0_rc1 6.0.0-rc1
test_PV_to_KV 6.0 6.0.0
test_PV_to_KV 6.0.1_rc1 6.0.1-rc1
test_PV_to_KV 6.0.1 6.0.1

test_compressed_module_cleanup

texit
