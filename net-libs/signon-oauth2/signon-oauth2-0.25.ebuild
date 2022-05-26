# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=signon-plugin-oauth2
MY_PV=VERSION_${PV}
MY_P=${MY_PN}-${MY_PV}
inherit qmake-utils

DESCRIPTION="OAuth2 plugin for Signon daemon"
HOMEPAGE="https://gitlab.com/accounts-sso/signon-plugin-oauth2"
SRC_URI="https://gitlab.com/accounts-sso/${MY_PN}/-/archive/${MY_PV}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	net-libs/signond
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	# downstream patches
	"${FILESDIR}/${PN}-0.24-dont-install-tests.patch"
	"${FILESDIR}/${P}-pkgconfig-libdir.patch"
	"${FILESDIR}/${P}-cxxflags.patch"
)

src_prepare() {
	default
	sed -i "s|@LIBDIR@|$(get_libdir)|g" src/signon-oauth2plugin.pc || die
}

src_configure() {
	local myqmakeargs=(
		LIBDIR=/usr/$(get_libdir)
	)
	use test || myqmakeargs+=( CONFIG+=nomake_tests )

	eqmake5 "${myqmakeargs[@]}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
