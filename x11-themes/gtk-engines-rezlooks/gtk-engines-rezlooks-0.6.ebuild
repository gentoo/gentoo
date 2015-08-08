# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

DESCRIPTION="Rezlooks GTK+ Engine"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=39179"
SRC_URI="http://www.gnome-look.org/content/files/39179-rezlooks-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.8:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/rezlooks-${PV}

src_prepare() {
	# automake complains: ChangeLog missing. There however is a Changelog.
	# to avoid problems with case insensitive fs, move somewhere else first.
	mv Changelog{,.1}
	mv Changelog.1 ChangeLog

	epatch "${FILESDIR}/${PN}-0.6-glib-single-include.patch"

	eautoreconf # required for interix
}

src_configure() {
	econf --disable-dependency-tracking --enable-animation
}

src_install() {
	default
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
}
