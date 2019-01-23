# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"
VALA_MIN_API_VERSION="0.34"
inherit cmake-utils gnome2-utils vala

DESCRIPTION="Modern Jabber/XMPP Client using GTK+/Vala"
HOMEPAGE="https://dino.im"
LICENSE="GPL-3"
SLOT="0"
IUSE="+gnupg +http +omemo"

MY_REPO_URI="https://github.com/dino/dino"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="${MY_REPO_URI}.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="${MY_REPO_URI}/archive/${PV}.tar.gz"
fi

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libgee:0.8
	net-libs/glib-networking
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	gnupg? ( app-crypt/gpgme:1 )
	http? ( net-libs/libsoup:2.4 )
	omemo? (
		dev-libs/libgcrypt:0
		media-gfx/qrencode
	)
"
DEPEND="
	$(vala_depend)
	${RDEPEND}
	sys-devel/gettext
"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local disabled_plugins=(
		$(usex gnupg "" "openpgp")
		$(usex omemo "" "omemo")
		$(usex http  "" "http-files")
	)
	local mycmakeargs+=(
		"-DDISABLED_PLUGINS=$(local IFS=";"; echo "${disabled_plugins[*]}")"
	)

	if has test ${FEATURES}; then
		mycmakeargs+=("-DBUILD_TESTS=yes")
	fi

	cmake-utils_src_configure
}

src_test() {
	"${BUILD_DIR}"/xmpp-vala-test || die
}

update_caches() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	update_caches
}

pkg_postrm() {
	update_caches
}
