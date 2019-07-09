# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils meson virtualx xdg-utils

DESCRIPTION="A highly customizable and functional document viewer"
HOMEPAGE="http://pwmt.org/projects/zathura/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://pwmt.org/projects/zathura/download/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="ZLIB"
SLOT="0"
IUSE="+magic seccomp sqlite synctex test"

RDEPEND=">=dev-libs/girara-0.3.1
	>=dev-libs/glib-2.50:2
	dev-python/sphinx
	>=sys-devel/gettext-0.19.8
	x11-libs/cairo
	>=x11-libs/gtk+-3.22:3
	magic? ( sys-apps/file )
	seccomp? ( sys-libs/libseccomp )
	sqlite? ( >=dev-db/sqlite-3.5.9:3 )
	synctex? ( app-text/texlive-core )"

DEPEND="${RDEPEND}
	test? ( dev-libs/check )"

BDEPEND="virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		-Denable-magic=$(usex magic true false)
		-Denable-seccomp=$(usex seccomp true false)
		-Denable-sqlite=$(usex sqlite true false)
		-Denable-synctex=$(usex synctex true false)
		)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
