# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="a derivative of the standard Tango theme, using a more orange approach"
HOMEPAGE="http://packages.ubuntu.com/gutsy/x11/tangerine-icon-theme"
SRC_URI="
	mirror://ubuntu/pool/universe/t/${PN}/${PN}_${PV}.tar.gz
	https://www.gentoo.org/images/gentoo-logo.svg"

LICENSE="CC-BY-SA-2.5 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"
RESTRICT="binchecks strip"

RDEPEND="
	!minimal? (
		|| (
			x11-themes/adwaita-icon-theme
			kde-frameworks/oxygen-icons
		)
	)"
BDEPEND="
	dev-util/intltool
	gnome-base/librsvg
	sys-devel/gettext
	x11-misc/icon-naming-utils"

PATCHES=( "${FILESDIR}"/${PN}-0.27-libexec.patch )

src_unpack() {
	unpack ${PN}_${PV}.tar.gz
}

src_prepare() {
	xdg_src_prepare

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
