# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 git-r3

DESCRIPTION="Common files shared between multiple slots of clang"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/llvm/llvm-project.git"
EGIT_BRANCH="release/9.x"
S=${WORKDIR}/${P}/clang

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

PDEPEND="sys-devel/clang:*"

src_unpack() {
	git-r3_fetch
	git-r3_checkout '' '' '' clang/utils/bash-autocomplete.sh
}

src_configure() { :; }
src_compile() { :; }
src_test() { :; }

src_install() {
	newbashcomp utils/bash-autocomplete.sh clang
}
