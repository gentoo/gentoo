# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
DESCRIPTION="Wrapper to coreutil's install to preserve Filesystem Extended Attributes"
HOMEPAGE="http://dev.gentoo.org/~blueness/install-xattr/"

inherit toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/elfix.git"
	KEYWORDS=""
	inherit git-2
else
	SRC_URI="http://dev.gentoo.org/~blueness/install-xattr/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	S=${WORKDIR}/${PN}
fi

LICENSE="GPL-3"
SLOT="0"

src_prepare() {
	tc-export CC
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
	default
}

# We need to fix how tests are done
src_test() {
	true
}
