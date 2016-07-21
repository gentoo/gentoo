# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"

inherit eutils flag-o-matic wxwidgets cmake-utils

MY_PV="${PV/_beta/BETA}"
DESCRIPTION="Password manager with wxGTK based frontend"
HOMEPAGE="https://pwsafe.org/ https://github.com/pwsafe/pwsafe/"
SRC_URI="https://github.com/pwsafe/pwsafe/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="minimal test yubikey +xml"

RDEPEND="xml? ( dev-libs/xerces-c )
	sys-apps/util-linux
	x11-libs/libXt
	x11-libs/libXtst
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	!minimal? ( !!app-misc/pwsafe )
	yubikey? ( sys-auth/ykpers )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	test? ( dev-cpp/gtest )"

S=${WORKDIR}/pwsafe-${MY_PV}

pkg_pretend() {
	einfo "Checking for -std=c++11 support in compiler"
	test-flags-CXX -std=c++11 > /dev/null || die
}

src_prepare() {
	# binary name pwsafe is in use by app-misc/pwsafe, we use passwordsafe
	# instead. Perform required changes in linking files
	sed -i install/desktop/pwsafe.desktop -e "s/pwsafe/${PN}/g" || die
	sed -i docs/pwsafe.1 \
		-e 's/PWSAFE/PASSWORDSAFE/' \
		-e "s/^.B pwsafe/.B ${PN}/" || die
	use test || sed -i -e '/find_package(GTest REQUIRED)/s/^/#/' \
		-e '/add_subdirectory (src\/test)/s/^/#/' CMakeLists.txt || die
}

src_configure() {
	need-wxwidgets unicode

	local mycmakeargs=( $(usex yubikey '' '-DNO_YUBI=ON')
		$(usex xml '' '-DNO_XML=ON') )

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

	# The upstream Makefile builds this .zip file from html source material for
	# use by the package's internal help system. Must prevent
	# Portage from applying additional compression.
	docompress -x /usr/share/doc/${PN}/help
	insinto /usr/share/doc/${PN}/help
	doins help/*.zip

	popd || die

	newman docs/pwsafe.1 ${PN}.1

	dodoc README.txt docs/{ReleaseNotes.txt,ChangeLog.txt}

	insinto /usr/share/pwsafe/xml
	doins xml/*

	newicon install/graphics/pwsafe.png ${PN}.png
	newmenu install/desktop/pwsafe.desktop ${PN}.desktop
}
