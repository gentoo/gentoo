# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit gnome2-utils

DESCRIPTION="a derivative of the standard Tango theme, using a more orange approach"
HOMEPAGE="http://packages.ubuntu.com/gutsy/x11/tangerine-icon-theme"
SRC_URI="mirror://ubuntu/pool/universe/t/${PN}/${PN}_${PV}.tar.gz
	https://www.gentoo.org/images/gentoo-logo.svg"

LICENSE="CC-BY-SA-2.5 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"

RESTRICT="binchecks strip"

RDEPEND="!minimal? ( || ( x11-themes/gnome-icon-theme kde-frameworks/oxygen-icons ) )"
DEPEND="dev-util/intltool
	>=gnome-base/librsvg-2.34
	sys-devel/gettext
	>=x11-misc/icon-naming-utils-0.8.90"

DOCS="AUTHORS README"

src_unpack() {
	unpack ${PN}_${PV}.tar.gz
}

src_prepare() {
	sed -i \
		-e 's:lib/icon-naming-utils/icon:libexec/icon:' \
		Makefile || die

	cp "${DISTDIR}"/gentoo-logo.svg scalable/places/start-here.svg || die

	local res
	for res in 16 22 32; do
		rsvg-convert -w ${res} -h ${res} scalable/places/start-here.svg \
			> ${res}x${res}/places/start-here.png || die
	done
}

src_compile() {
	emake index.theme
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
