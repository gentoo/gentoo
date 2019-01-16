# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Common files shared between multiple slots of LLVM"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://git.llvm.org/git/llvm.git
	https://github.com/llvm-mirror/llvm.git"
EGIT_BRANCH="release_80"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="!sys-devel/llvm:0"

src_unpack() {
	git-r3_fetch
	git-r3_checkout '' '' '' utils/vim
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
