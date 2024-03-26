# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson virtualx xdg

DESCRIPTION="A highly customizable and functional document viewer"
HOMEPAGE="https://pwmt.org/projects/zathura/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="
		https://github.com/pwmt/zathura/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://cdn.turret.cyou/e28b2f940d1a19a74ecbfd80ea4477c5ea9ac627/${P}-manpages.tar.xz
	"
	KEYWORDS="~amd64 ~arm ~riscv ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="ZLIB"
SLOT="0/5.6"
IUSE="seccomp sqlite synctex test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/girara-0.4.1
	>=dev-libs/glib-2.50:2
	dev-libs/json-glib
	sys-apps/file
	x11-libs/cairo
	>=x11-libs/gtk+-3.22:3
	seccomp? ( sys-libs/libseccomp )
	sqlite? ( >=dev-db/sqlite-3.6.23:3 )
	synctex? ( app-text/texlive-core )
"
DEPEND="
	${RDEPEND}
	test? (
		dev-libs/check
		>=x11-libs/gtk+-3.22:3[X]
	)
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/zathura-0.5.4-disable-seccomp-tests.patch"
)

src_configure() {
	local emesonargs=(
		-Dconvert-icon=disabled
		-Dmanpages=disabled
		-Dseccomp=$(usex seccomp enabled disabled)
		-Dsqlite=$(usex sqlite enabled disabled)
		-Dsynctex=$(usex synctex enabled disabled)
		)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

src_install() {
	meson_src_install
	[[ ${PV} != *9999 ]] && doman "${WORKDIR}"/man/zathura*
}
