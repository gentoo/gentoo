# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0-gtk3"

inherit desktop flag-o-matic wxwidgets cmake-utils

MY_PV="${PV/_beta/BETA}"
DESCRIPTION="Password manager with wxGTK based frontend"
HOMEPAGE="https://pwsafe.org/ https://github.com/pwsafe/pwsafe/"
SRC_URI="https://github.com/pwsafe/pwsafe/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl minimal test qr yubikey +xml xvkbd"
RESTRICT="!test? ( test )"

COMMON_DEPEND="xml? ( dev-libs/xerces-c )
	qr? ( media-gfx/qrencode )
	net-misc/curl
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-apps/util-linux
	x11-libs/libXt
	x11-libs/libXtst
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	!minimal? ( !!app-misc/pwsafe )
	yubikey? ( sys-auth/ykpers )"
RDEPEND="${COMMON_DEPEND}
	xvkbd? ( x11-misc/xvkbd )"
DEPEND="${COMMON_DEPEND}
	app-arch/zip
	sys-devel/gettext
	test? ( dev-cpp/gtest )"

S=${WORKDIR}/pwsafe-${MY_PV}

PATCHES=(
	"${FILESDIR}/${PN}-1.06_beta-system-gtest.patch"
)

pkg_pretend() {
	einfo "Checking for -std=c++11 support in compiler"
	test-flags-CXX -std=c++11 > /dev/null || die
}

src_prepare() {
	cmake-utils_src_prepare

	# binary name pwsafe is in use by app-misc/pwsafe, we use passwordsafe
	# instead. Perform required changes in linking files
	sed -i install/desktop/pwsafe.desktop -e "s/pwsafe/${PN}/g" || die
	sed -i docs/pwsafe.1 \
		-e 's/PWSAFE/PASSWORDSAFE/' \
		-e "s/^.B pwsafe/.B ${PN}/" || die
}

src_configure() {
	need-wxwidgets unicode

	local mycmakeargs=(
		-DNO_QR=$(usex !qr)
		-DNO_GTEST=$(usex !test)
		-DSYSTEM_GTEST=ON
		-DXML_XERCESC=$(usex xml)
		-DNO_YUBI=$(usex !yubikey)
	)

	cmake-utils_src_configure
}

src_install() {
	pushd "${BUILD_DIR}" || die
	if use minimal; then
		newbin pwsafe ${PN}
	else
		dobin pwsafe
		dosym pwsafe /usr/bin/${PN}
	fi
	insinto /usr/share/locale
	doins -r src/ui/wxWidgets/I18N/mos/*

	insinto /usr/share/${PN}/help
	doins help/*.zip

	popd || die

	newman docs/pwsafe.1 ${PN}.1

	dodoc README.md README.LINUX.* docs/{ReleaseNotes.txt,ChangeLog.txt}

	insinto /usr/share/${PN}
	doins -r xml

	newicon install/graphics/pwsafe.png ${PN}.png
	newmenu install/desktop/pwsafe.desktop ${PN}.desktop
}
