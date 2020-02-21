# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="A nice and well polished icon theme"
HOMEPAGE="http://packages.ubuntu.com/lucid/human-icon-theme"
SRC_URI="
	mirror://ubuntu/pool/universe/h/${PN}/${PN}_${PV}.tar.gz
	https://www.gentoo.org/images/gentoo-logo.svg"

LICENSE="CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="binchecks strip"

RDEPEND="
	|| (
		x11-themes/adwaita-icon-theme
		x11-themes/tangerine-icon-theme
	)"
BDEPEND="
	dev-util/intltool
	gnome-base/librsvg
	sys-devel/gettext
	x11-misc/icon-naming-utils"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${PN}-0.36-fix-buildsystem.patch )

src_prepare() {
	xdg_src_prepare

	cp "${DISTDIR}"/gentoo-logo.svg scalable/places/start-here.svg || die

	local res
	for res in 22 32 48; do
		rsvg-convert -w ${res} -h ${res} scalable/places/start-here.svg \
			> ${res}x${res}/places/start-here.png || die
	done
}

src_compile() {
	emake index.theme
}
