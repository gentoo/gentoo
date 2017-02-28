# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Vim support files for LLVM"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://www.llvm.org/pre-releases/${PV/_//}/llvm-${PV/_/}.src.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="!sys-devel/llvm:0"

S=${WORKDIR}/llvm-${PV/_/}.src/utils/vim

src_install() {
	insinto /usr/share/vim/vimfiles
	doins -r */
	# some users may find it useful
	dodoc README vimrc
}
