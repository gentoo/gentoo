# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Common files shared between multiple slots of LLVM"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/llvm/llvm-project.git"
S=${WORKDIR}/${P}/llvm

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="!sys-devel/llvm:0"

src_unpack() {
	git-r3_fetch
	git-r3_checkout '' '' '' llvm/utils/vim
}

src_configure() { :; }
src_compile() { :; }
src_test() { :; }

src_install() {
	insinto /usr/share/vim/vimfiles
	doins -r utils/vim/*/
	# some users may find it useful
	newdoc utils/vim/README README.vim
	dodoc utils/vim/vimrc
}
