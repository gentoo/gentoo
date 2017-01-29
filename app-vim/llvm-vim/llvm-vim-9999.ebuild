# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Vim support files for LLVM"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/llvm.git
	https://github.com/llvm-mirror/llvm.git"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="!sys-devel/llvm:0"

S=${WORKDIR}/${P}/utils/vim

src_install() {
	insinto /usr/share/vim/vimfiles
	doins -r */
	# some users may find it useful
	dodoc README vimrc
}
