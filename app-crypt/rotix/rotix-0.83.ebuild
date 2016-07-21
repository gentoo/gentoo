# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic

DESCRIPTION="Rotix allows you to generate rotational obfuscations"
HOMEPAGE="https://gentoo.org"
SRC_URI="http://elektron.its.tudelft.nl/~hemmin98/rotix_releases/${P}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND="sys-devel/gettext"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-respect-CFLAGS-and-dont-strip.patch
	epatch "${FILESDIR}"/${P}-locale.diff
	epatch "${FILESDIR}"/${P}-interix.patch
}

src_configure() {
	use elibc_glibc || append-flags -lintl
	econf --i18n=1
}

src_install() {
	emake DESTDIR="${D}" install || die
}
