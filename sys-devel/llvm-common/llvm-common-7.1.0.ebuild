# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=llvm-${PV/_/}.src
DESCRIPTION="Common files shared between multiple slots of LLVM"
HOMEPAGE="https://llvm.org/"
SRC_URI="https://releases.llvm.org/${PV/_//}/${MY_P}.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="!sys-devel/llvm:0"

S=${WORKDIR}/${MY_P}

src_unpack() {
	einfo "Unpacking parts of ${MY_P}.tar.xz ..."
	tar -xJf "${DISTDIR}/${MY_P}.tar.xz" "${MY_P}/utils/vim" || die
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
