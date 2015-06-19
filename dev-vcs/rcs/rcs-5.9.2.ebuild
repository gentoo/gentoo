# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/rcs/rcs-5.9.2.ebuild,v 1.2 2014/11/13 02:10:02 idella4 Exp $

EAPI="4"

inherit eutils

DESCRIPTION="Revision Control System"
HOMEPAGE="http://www.gnu.org/software/rcs/"
SRC_URI="mirror://gnu/rcs/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd \
~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="doc"

RDEPEND="
	sys-apps/diffutils
	sys-apps/ed"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e '/gets is a security hole/d' \
		lib/stdio.in.h || die
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog NEWS README

	if use doc; then
		emake -C doc html
		rm -R "${ED}/usr/share/doc/rcs"
		mv doc/rcs.html doc/html
		dodoc -r doc/html/
	fi
}
