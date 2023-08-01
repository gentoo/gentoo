# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: crossdev.eclass
# @MAINTAINER:
# cat@catcream.org
# @AUTHOR:
# Alfred Persson Forsberg <cat@catcream.org> (21 Jul 2023)
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Convenience wrappers for packages used by the Crossdev tool.

inherit toolchain-funcs

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_CROSSDEV_ECLASS} ]]; then
_CROSSDEV_ECLASS=1

# @ECLASS_VARIABLE: _CROSS_CATEGORY_PREFIX
# @INTERNAL
# @DESCRIPTION:
# This variable specifies the category prefix for a Crossdev
# package. For GCC Crossdev it is "cross-", and for LLVM it is
# "cross_llvm-"
_CROSS_CATEGORY_PREFIX=""

# @ECLASS_VARIABLE: _IS_CROSSPKG_LLVM
# @INTERNAL
# @DESCRIPTION:
# Is true if the package is in a LLVM Crossdev category, otherwise false
_IS_CROSSPKG_LLVM=0
if [[ ${CATEGORY} == cross_llvm-* ]] ; then
	_IS_CROSSPKG_LLVM=1
	_CROSS_CATEGORY_PREFIX="cross_llvm-"
fi

# @ECLASS_VARIABLE: _IS_CROSSPKG_GCC
# @INTERNAL
# @DESCRIPTION:
# Is true if the package is in a GCC Crossdev category, otherwise false
_IS_CROSSPKG_GCC=0
if [[ ${CATEGORY} == cross-* ]] ; then
	_IS_CROSSPKG_GCC=1
	_CROSS_CATEGORY_PREFIX="cross-"
fi

# @ECLASS_VARIABLE: _IS_CROSSPKG
# @INTERNAL
# @DESCRIPTION:
# Is true if the package is in a any Crossdev category, otherwise false
[[ ${_IS_CROSSPKG_LLVM} == 1 || ${_IS_CROSSPKG_GCC} == 1 ]] && _IS_CROSSPKG=1

# Default CBUILD and CTARGET to CHOST if unset.
export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}

if [[ ${CTARGET} == ${CHOST} ]] ; then
	# cross-aarch64-gentoo-linux-musl -> aarch64-gentoo-linux-musl
	[[ ${_IS_CROSSPKG} == 1 ]] && export CTARGET=${CATEGORY#${_CROSS_CATEGORY_PREFIX}}
fi

# @FUNCTION: target_is_not_host
# @RETURN: Shell true if we're targeting an triple other than host
target_is_not_host() {
	 [[ ${CHOST} != ${CTARGET} ]]
}

# @FUNCTION: is_crosspkg
# @RETURN: Shell true if package belongs to any crossdev category
is_crosspkg() {
	 [[ ${_IS_CROSSPKG} == 1 ]]
}

fi
