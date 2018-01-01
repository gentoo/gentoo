# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
SQL_REQUIRED="always"
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
inherit kde4-base

DESCRIPTION="Personal finance manager by KDE"
HOMEPAGE="https://kmymoney.org/"
if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="calendar debug doc hbci ofx quotes weboob"

COMMON_DEPEND="
	>=app-crypt/gpgme-1.7.0[cxx]
	<app-office/libalkimia-6.0.0
	dev-libs/gmp:0=
	dev-libs/libgpg-error
	x11-misc/shared-mime-info
	calendar? ( dev-libs/libical:= )
	hbci? (
		>=net-libs/aqbanking-5.5.1
		>=sys-libs/gwenhywfar-4.15.3[qt4]
	)
	ofx? ( >=dev-libs/libofx-0.9.4 )
	weboob? ( www-client/weboob )
"
RDEPEND="${COMMON_DEPEND}
	quotes? ( dev-perl/Finance-Quote )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	kde4-base_src_prepare

	# don't install as executable
	sed -i kmymoney/CMakeLists.txt \
		-e "/install.*kmymoney.appdata/ s/PROGRAMS/FILES/" || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_QT_DESIGNER=OFF
		-DENABLE_LIBICAL=$(usex calendar)
		-DUSE_DEVELOPER_DOC=$(usex doc)
		-DENABLE_KBANKING=$(usex hbci)
		-DENABLE_LIBOFX=$(usex ofx)
		-DCMAKE_DISABLE_FIND_PACKAGE_KdepimLibs=ON
		-DENABLE_WEBOOB=$(usex weboob)
	)
	kde4-base_src_configure
}

src_compile() {
	kde4-base_src_compile
	use doc && kde4-base_src_compile apidoc
}

src_install() {
	use doc && HTML_DOCS=("${BUILD_DIR}/apidocs/html/")
	kde4-base_src_install
}
