# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libunicode/libunicode-0.4-r1.ebuild,v 1.35 2011/03/19 20:22:42 mr_bones_ Exp $

EAPI=3
inherit autotools toolchain-funcs

DESCRIPTION="Unicode library"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/sources/${PN}/${PV}/${P}.gnome.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc sparc x86"
IUSE=""

src_prepare() {
	# The build system is too old, regenerate here to fix crossbuild and
	# respect LDFLAGS and probably other problems too.
	sed -i -e "/testsuite/d" configure.in || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO || die "dodoc failed"
}
