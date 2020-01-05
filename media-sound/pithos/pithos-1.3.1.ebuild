# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )
inherit autotools gnome2-utils python-r1

if [[ ${PV} =~ [9]{4,} ]]; then
	inherit git-2
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Pandora.com client for the GNOME desktop"
HOMEPAGE="https://pithos.github.io/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libnotify appindicator +keybinder"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	dev-python/pylast[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.12[${PYTHON_USEDEP}]
	dev-libs/appstream-glib[introspection]
	x11-libs/pango[introspection]
	media-libs/gstreamer:1.0[introspection]
	media-plugins/gst-plugins-meta:1.0[aac,http,mp3]
	>=x11-libs/gtk+-3.14:3[introspection]
	x11-themes/gnome-icon-theme-symbolic
	libnotify? ( x11-libs/libnotify[introspection] )
	appindicator? ( dev-libs/libappindicator:3[introspection] )
	keybinder? ( dev-libs/keybinder:3[introspection] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.1-dont-try-to-update-icon-cache.patch"
)

src_prepare() {
	default
	eautoreconf
	python_copy_sources
}

pithos_src_configure() {
	pushd "${BUILD_DIR}" || die
	econf UPDATE_ICON_CACHE=":"
	popd || die
}

src_configure() {
	python_foreach_impl pithos_src_configure
}

pithos_src_compile() {
	pushd "${BUILD_DIR}" || die
	emake
	popd || die
}

src_compile() {
	python_foreach_impl pithos_src_compile
}

pithos_src_install() {
	pushd "${BUILD_DIR}" || die
	emake DESTDIR="${D}" install
	python_doscript "${D}"/usr/bin/pithos
	popd || die
}

src_install() {
	python_foreach_impl pithos_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}
pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
