# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="Revision Control System"
HOMEPAGE="https://www.gnu.org/software/rcs/"
SRC_URI="mirror://gnu/rcs/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="doc"

RDEPEND="
	sys-apps/diffutils
	sys-apps/ed"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e '/gets is a security hole/d' \
		lib/stdio.in.h || die
}

src_configure() {
	append-flags -std=gnu99
	econf
}

src_test() {
	emake check
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc ChangeLog NEWS README

	if use doc; then
		emake -C doc html
		rm -R "${ED}/usr/share/doc/rcs"
		mv doc/rcs.html doc/html
		dodoc -r doc/html/
	fi
}
