# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit python-single-r1 xdg

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/exaile/exaile.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV/_/-}/${PN}-${PV/_/}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${PV/_/-}"
fi

DESCRIPTION="GTK+ based media player aiming to be similar to Amarok"
HOMEPAGE="https://www.exaile.org/"
LICENSE="GPL-2 GPL-3"
SLOT="0"
# IUSE+=cddb if have dev-python/cddb-py
IUSE="libnotify nls scrobbler"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
"
RDEPEND="${PYTHON_DEPS}
	>=media-libs/gst-plugins-base-1.6:1.0
	>=media-libs/gst-plugins-good-1.4:1.0
	media-plugins/gst-plugins-meta:1.0
	>=x11-libs/gtk+-3.10:3[introspection]
	libnotify? ( >=x11-libs/libnotify-0.7[introspection] )
	$(python_gen_cond_dep '
		dev-python/bsddb3[${PYTHON_MULTI_USEDEP}]
		dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
		dev-python/gst-python:1.0[${PYTHON_MULTI_USEDEP}]
		dev-python/pycairo[${PYTHON_MULTI_USEDEP}]
		>=dev-python/pygobject-3.13.2:3[${PYTHON_MULTI_USEDEP}]
		>=media-libs/mutagen-1.10[${PYTHON_MULTI_USEDEP}]
		scrobbler? ( dev-python/pylast[${PYTHON_MULTI_USEDEP}] )
	')
"

RESTRICT="test" #315589

PATCHES=(
	"${FILESDIR}/${PN}-4.1.1-metainfo.patch"
)

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
