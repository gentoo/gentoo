# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit gnome2-utils python-r1

DESCRIPTION="GNOME integration for Spotify"
HOMEPAGE="https://github.com/mrpdaemon/gnome-integration-spotify"
#SRC_URI="https://github.com/mrpdaemon/${PN}/tarball/${PV} -> ${PN}-git-${PV}.tgz"
SRC_URI="https://github.com/mrpdaemon/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
#S="${WORKDIR}/mrpdaemon-${PN}-df9124d"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	media-gfx/imagemagick
	x11-misc/wmctrl
	x11-misc/xautomation
	x11-misc/xdotool
	x11-apps/xwininfo"

src_install() {
	dobin spotify-dbus.py
	python_replicate_script "${ED}"/usr/bin/spotify-dbus.py
	mkdir -p "${D}/etc/gconf/schemas"
	cp spotify.schemas "${D}/etc/gconf/schemas"
}

pkg_preinst() {
	gnome2_gconf_savelist
}

pkg_postinst() {
	gnome2_gconf_install
}

pkg_prerm() {
	gnome2_gconf_uninstall
}
