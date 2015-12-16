# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
DESCRIPTION="Wrapper to coreutil's install to preserve Filesystem Extended Attributes"
HOMEPAGE="https://dev.gentoo.org/~blueness/install-xattr/"

inherit toolchain-funcs

S="${WORKDIR}/${PN}"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/elfix.git"
	EGIT_CHECKOUT_DIR="${S}"
	S+=/misc/${PN}
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~blueness/install-xattr/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

src_prepare() {
	tc-export CC
	sed -e "s|^\\(PREFIX = \\)\\(/usr\\)$|\\1${EPREFIX}\\2|" \
		-i Makefile || die "sed Makefile failed"
}

# We need to fix how tests are done
src_test() {
	return 0
}
