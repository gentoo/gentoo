#!/bin/bash
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

source tests-common.sh || exit

EAPI=8

test_globals() {
	local compat=${1}
	local expected_iuse=${2}
	local expected_required_use=${3}
	local expected_usedep=${4}
	local x

	tbegin "LLVM_COMPAT=( ${compat} )"

	(
		local fail=0
		local LLVM_COMPAT=( ${compat} )

		inherit llvm-r2

		if [[ ${IUSE%% } != ${expected_iuse} ]]; then
			eerror "          IUSE: ${IUSE%% }"
			eerror "does not match: ${expected_iuse}"
			fail=1
		fi

		if [[ ${REQUIRED_USE} != ${expected_required_use} ]]; then
			eerror "  REQUIRED_USE: ${REQUIRED_USE}"
			eerror "does not match: ${expected_required_use}"
			fail=1
		fi

		if [[ ${LLVM_USEDEP} != ${expected_usedep} ]]; then
			eerror "   LLVM_USEDEP: ${LLVM_USEDEP}"
			eerror "does not match: ${expected_usedep}"
			fail=1
		fi

		exit "${fail}"
	)

	tend "${?}"
}

test_gen_dep() {
	local arg=${1}
	local expected
	read -r -d '' expected

	tbegin "llvm_gen_dep ${arg}"
	local value=$(llvm_gen_dep "${arg}")

	if [[ ${value} != ${expected} ]]; then
		eerror "llvm_gen_dep ${arg}"
		eerror "gave:"
		eerror "  ${value}"
		eerror "expected:"
		eerror "  ${expected}"
	fi
	tend ${?}
}

LLVM_CONFIG_OPTIONS=(
	--assertion-mode
	--bindir
	--build-mode
	--build-system
	--cflags
	--cmakedir
	--components
	--cppflags
	--cxxflags
	--has-rtti
	--host-target
	--ignore-libllvm
	--includedir
	--ldflags
	--libdir
	--libfiles
	--libnames
	--libs
	--link-shared
	--link-static
	--obj-root
	--prefix
	--shared-mode
	--system-libs
	--targets-built
	--version
)

normalize_list() {
	"${@}" |
		sed -e 's:\s\+:\n:g' |
		sed -e '/^$/d' |
		sort
	local ps=${PIPESTATUS[*]}
	[[ ${ps} == '0 0 0 0' ]] || die "normalize_list pipe failed: ${ps}"
}

test_llvm_config() {
	einfo "llvm-config for slot ${LLVM_SLOT}, libdir ${LLVM_LIBDIR}"
	eindent

	generate_llvm_config > "${TMP}/llvm-config" || die
	local triple=$(sh "${TMP}/llvm-config" --host-target || die)
	local llvm_config=/usr/lib/llvm/${LLVM_SLOT}/bin/${triple}-llvm-config

	local option res
	for option in "${LLVM_CONFIG_OPTIONS[@]}"; do
		tbegin "${option}"

		normalize_list sh "${TMP}/llvm-config" "${option}" > "${TMP}/our"
		normalize_list "${llvm_config}" "${option}" > "${TMP}/upstream"
		case ${option} in
			--components)
				# our components are a superset of what llvm-config yields
				res=$(comm -13 "${TMP}/our" "${TMP}/upstream")
				;;
			*)
				# expect all elements to match
				res=$(comm -3 "${TMP}/our" "${TMP}/upstream")
				;;
		esac

		if [[ -z ${res} ]]; then
			tend 0
		else
			eerror "$(diff -u "${TMP}/our" "${TMP}/upstream")"
			tend 1
		fi
	done
	
	eoutdent
}

# full range
test_globals '14 15 16 17 18 19' \
	"+llvm_slot_19 llvm_slot_15 llvm_slot_16 llvm_slot_17 llvm_slot_18" \
	"^^ ( llvm_slot_15 llvm_slot_16 llvm_slot_17 llvm_slot_18 llvm_slot_19 )" \
	"llvm_slot_15(-)?,llvm_slot_16(-)?,llvm_slot_17(-)?,llvm_slot_18(-)?,llvm_slot_19(-)?"
test_globals '14 15 16 17 18' \
	"+llvm_slot_18 llvm_slot_15 llvm_slot_16 llvm_slot_17" \
	"^^ ( llvm_slot_15 llvm_slot_16 llvm_slot_17 llvm_slot_18 )" \
	"llvm_slot_15(-)?,llvm_slot_16(-)?,llvm_slot_17(-)?,llvm_slot_18(-)?"
# older than stable
test_globals '14 15 16' \
	"+llvm_slot_16 llvm_slot_15" \
	"^^ ( llvm_slot_15 llvm_slot_16 )" \
	"llvm_slot_15(-)?,llvm_slot_16(-)?"
# old + newer than current stable
test_globals '15 20' \
	"+llvm_slot_15 llvm_slot_20" \
	"^^ ( llvm_slot_15 llvm_slot_20 )" \
	"llvm_slot_15(-)?,llvm_slot_20(-)?"
# newer than current stable
test_globals '19' \
	"+llvm_slot_19" \
	"^^ ( llvm_slot_19 )" \
	"llvm_slot_19(-)?"

LLVM_COMPAT=( {14..18} )
inherit llvm-r2

test_gen_dep 'llvm-core/llvm:${LLVM_SLOT} llvm-core/clang:${LLVM_SLOT}' <<-EOF
	llvm_slot_15? ( llvm-core/llvm:15 llvm-core/clang:15 )
	llvm_slot_16? ( llvm-core/llvm:16 llvm-core/clang:16 )
	llvm_slot_17? ( llvm-core/llvm:17 llvm-core/clang:17 )
	llvm_slot_18? ( llvm-core/llvm:18 llvm-core/clang:18 )
EOF

TMP=$(mktemp -d || die)
trap 'rm -rf \"${TMP}\"' EXIT
get_libdir() { echo "${LLVM_LIBDIR}"; }

for installed_llvm_cmake in /usr/lib/llvm/*/lib*/cmake; do
	installed_llvm_libdir=${installed_llvm_cmake%/*}
	LLVM_LIBDIR=${installed_llvm_libdir##*/}
	installed_llvm=${installed_llvm_libdir%/*}
	LLVM_SLOT=${installed_llvm##*/}

	test_llvm_config
done

texit
