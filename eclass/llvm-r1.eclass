# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: llvm-r1.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: llvm-utils
# @BLURB: Provide LLVM_SLOT to build against slotted LLVM
# @DESCRIPTION:
# An eclass to reliably depend on a set of LLVM-related packages
# in a matching slot.  To use the eclass:
#
# 1. Set LLVM_COMPAT to the list of supported LLVM slots.
#
# 2. Use llvm_gen_dep and/or LLVM_USEDEP to add appropriate
#    dependencies.
#
# 3. Use llvm-r1_pkg_setup, get_llvm_prefix or LLVM_SLOT.
#
# The eclass sets IUSE and REQUIRED_USE.  The flag corresponding
# to the newest supported stable LLVM slot (or the newest testing,
# if no stable slots are supported) is enabled by default.
#
# Example:
# @CODE
# LLVM_COMPAT=( {16..18} )
#
# inherit llvm-r1
#
# DEPEND="
#   dev-libs/libfoo[${LLVM_USEDEP}]
#   $(llvm_gen_dep '
#     llvm-core/clang:${LLVM_SLOT}=
#     llvm-core/llvm:${LLVM_SLOT}=
#   ')
# "
# @CODE

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_LLVM_R1_ECLASS} ]]; then
_LLVM_R1_ECLASS=1

inherit llvm-r2

llvm-r1_pkg_setup() {
	llvm-r2_pkg_setup
}

fi

if [[ ! ${LLVM_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS pkg_setup
fi
