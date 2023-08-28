# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson virtualx xdg

DESCRIPTION="A highly customizable and functional document viewer"
HOMEPAGE="https://pwmt.org/projects/zathura/"

inherit git-r3
EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
EGIT_BRANCH="develop"

LICENSE="ZLIB"
SLOT="0/$(ver_cut 1-2)"
IUSE="doc seccomp sqlite synctex test"

RESTRICT="!test? ( test )"

DEPEND=">=dev-libs/girara-0.3.7
	>=dev-libs/glib-2.50:2
	sys-apps/file
	>=sys-devel/gettext-0.19.8
	x11-libs/cairo
	>=x11-libs/gtk+-3.22:3
	seccomp? ( sys-libs/libseccomp )
	sqlite? ( >=dev-db/sqlite-3.5.9:3 )
	synctex? ( app-text/texlive-core )"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-python/sphinx
	virtual/pkgconfig
	test? ( dev-libs/appstream-glib
		dev-libs/check
		x11-base/xorg-server[xvfb] ) "

PATCHES=(
	"${FILESDIR}"/zathura-disable-seccomp-tests.patch
)

src_configure() {
	local emesonargs=(
		-Dconvert-icon=disabled
		-Dmanpages=enabled
		-Dseccomp=$(usex seccomp enabled disabled)
		-Dsqlite=$(usex sqlite enabled disabled)
		-Dsynctex=$(usex synctex enabled disabled)
		)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
