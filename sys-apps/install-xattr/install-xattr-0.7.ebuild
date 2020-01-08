# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Wrapper to coreutil's install to preserve Filesystem Extended Attributes"
HOMEPAGE="https://dev.gentoo.org/~blueness/install-xattr/"

inherit flag-o-matic toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/elfix.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~blueness/install-xattr/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"
	S=${WORKDIR}/${PN}
fi

LICENSE="GPL-3"
SLOT="0"

src_prepare() {
	default
	tc-export CC
	append-cppflags "-D_FILE_OFFSET_BITS=64"
}

src_compile() {
	if [[ ${PV} == "9999" ]] ; then
		cd "${WORKDIR}/${P}/misc/${PN}" || die
	fi
	default
}

src_install() {
	if [[ ${PV} == "9999" ]] ; then
		cd "${WORKDIR}/${P}/misc/${PN}" || die
	fi
	DESTDIR=${ED} emake install
}

# We need to fix how tests are done
src_test() {
	true
}
