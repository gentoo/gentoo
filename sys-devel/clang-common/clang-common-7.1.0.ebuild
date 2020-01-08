# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1

MY_P=cfe-${PV/_/}.src
DESCRIPTION="Common files shared between multiple slots of clang"
HOMEPAGE="https://llvm.org/"
SRC_URI="https://releases.llvm.org/${PV/_//}/${MY_P}.tar.xz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

PDEPEND="sys-devel/clang:*"

S=${WORKDIR}/${MY_P}

src_unpack() {
	einfo "Unpacking parts of ${MY_P}.tar.xz ..."
	tar -xJf "${DISTDIR}/${MY_P}.tar.xz" "${MY_P}/utils/bash-autocomplete.sh" || die
}

src_configure() { :; }
src_compile() { :; }
src_test() { :; }

src_install() {
	newbashcomp utils/bash-autocomplete.sh clang
}
