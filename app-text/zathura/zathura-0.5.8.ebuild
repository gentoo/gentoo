# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson virtualx xdg

DESCRIPTION="A highly customizable and functional document viewer"
HOMEPAGE="https://pwmt.org/projects/zathura/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pwmt/zathura.git"
else
	SRC_URI="
		https://github.com/pwmt/zathura/archive/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="amd64 arm ~arm64 ~riscv x86"
fi

LICENSE="ZLIB"
SLOT="0/6.7"
IUSE="+man seccomp synctex test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/json-glib
	man? ( dev-python/sphinx )
	seccomp? ( sys-libs/libseccomp )
	synctex? ( app-text/texlive-core )
	sys-apps/file
	x11-libs/cairo
	x11-libs/pango
	>=dev-db/sqlite-3.6.23:3
	>=dev-libs/girara-0.4.3:=
	>=dev-libs/glib-2.72:2
	>=x11-libs/gtk+-3.24:3
"
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-5.13
	test? (
		dev-libs/check
		>=x11-libs/gtk+-3.24:3[X]
	)
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dconvert-icon=disabled
		-Dlandlock=enabled
		-Dmanpages=$(usex man enabled disabled)
		-Dseccomp=$(usex seccomp enabled disabled)
		-Dsynctex=$(usex synctex enabled disabled)
		$(meson_feature test tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

src_install() {
	meson_src_install
}
