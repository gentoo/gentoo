# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 llvm.org

DESCRIPTION="Common files shared between multiple slots of clang"
HOMEPAGE="https://llvm.org/"
LLVM_COMPONENTS=( clang/utils/bash-autocomplete.sh )
llvm.org_set_globals
S=${WORKDIR}/clang/utils

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

PDEPEND="sys-devel/clang:*"

src_prepare() {
	cd "${WORKDIR}" || die
	default
}

src_install() {
	newbashcomp bash-autocomplete.sh clang
}
