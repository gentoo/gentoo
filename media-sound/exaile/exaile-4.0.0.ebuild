# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
inherit python-single-r1 xdg-utils

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/exaile/exaile.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV/_/-}/${PN}-${PV/_/}.tar.gz"
	KEYWORDS="amd64 ~sparc x86"
	S="${WORKDIR}/${PN}-${PV/_/}"
fi

DESCRIPTION="GTK+ based media player aiming to be similar to Amarok"
HOMEPAGE="https://www.exaile.org/"

LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE="cddb libnotify nls scrobbler"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/bsddb3[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gst-python:1.0[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.13.2:3[${PYTHON_USEDEP}]
	>=media-libs/gst-plugins-base-1.6:1.0
	>=media-libs/gst-plugins-good-1.4:1.0
	>=media-libs/mutagen-1.10[${PYTHON_USEDEP}]
	media-plugins/gst-plugins-meta:1.0
	>=x11-libs/gtk+-3.10:3[introspection]
	cddb? ( dev-python/cddb-py )
	libnotify? ( >=x11-libs/libnotify-0.7[introspection] )
	scrobbler? ( dev-python/pylast[${PYTHON_USEDEP}] )
"
BDEPEND="
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
"

RESTRICT="test" #315589

pkg_setup() {
	python-single-r1_pkg_setup
}

src_compile() {
	use nls && emake locale
}

src_install() {
	emake \
		PREFIX=/usr \
		LIBINSTALLDIR=/usr/$(get_libdir) \
		DESTDIR="${D}" \
		install$(use nls || echo _no_locale)

	python_optimize "${D}/usr/$(get_libdir)/${PN}"
	python_optimize "${D}/usr/share/${PN}"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
