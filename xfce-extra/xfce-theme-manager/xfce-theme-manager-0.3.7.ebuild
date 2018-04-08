# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=Xfce-Theme-Manager
MY_P=${MY_PN}-${PV}

DESCRIPTION="An alternative theme manager for The Xfce Desktop Environment"
HOMEPAGE="http://khapplications.darktech.org/pages/apps.html#themeed"
SRC_URI="https://dl.dropboxusercontent.com/s/bh16k3am8q7zvat/${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.30
	>=x11-libs/gtk+-2.24:2
	x11-libs/libXcursor
	>=xfce-base/libxfce4ui-4.10:=
	>=xfce-base/xfconf-4.10:=
	>=xfce-base/xfdesktop-4.10:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-0.3.6-format-security.patch
	)

	default

	sed -i \
		-e '/^Cat/s:;;Settings::' \
		-e '/^Cat/s:Gnome:GNOME:' \
		${MY_PN}/resources/pixmaps/${MY_PN}.desktop || die

	local desktopversion=10
	has_version '>=xfce-base/xfdesktop-4.11' && desktopversion=11

	sed -i \
		-e '/^CFLAGS/s:-Wall:& ${CFLAGS}:' \
		-e '/^CXXFLAGS/s:-Wall:& ${CXXFLAGS}:' \
		-e "/^desktopversion/s:=.*:=${desktopversion}:" \
		configure || die
}

src_install() {
	default
	find "${D}" -name '*.gz' -exec gzip -d {} + || die
	rm -f "${ED%/}"/usr/share/${MY_PN}/docs/gpl-3.0.txt || die
}
