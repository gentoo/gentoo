# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="bs ca ca@valencia cs da de el en_GB es et eu fi fr gl
hu it kk nds nl pl pt pt_BR ro ru sv uk zh_TW"
KDE_HANDBOOK="optional"
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
inherit kde4-base

DESCRIPTION="Personal finance manager for KDE"
HOMEPAGE="http://kmymoney2.sourceforge.net/"
if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug calendar doc hbci ofx quotes"

COMMON_DEPEND="
	app-crypt/gpgme
	>=app-office/libalkimia-4.3.2
	dev-libs/gmp:0
	dev-libs/libgpg-error
	$(add_kdebase_dep kdepimlibs)
	x11-misc/shared-mime-info
	calendar? ( dev-libs/libical:= )
	hbci? (
		>=net-libs/aqbanking-5.0.1
		>=sys-libs/gwenhywfar-4.0.1[qt4]
	)
	ofx? ( >=dev-libs/libofx-0.9.4 )
"
RDEPEND="${COMMON_DEPEND}
	quotes? ( dev-perl/Finance-Quote )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT_DESIGNER=OFF
		$(cmake-utils_use_enable calendar LIBICAL)
		$(cmake-utils_use_use doc DEVELOPER_DOC)
		$(cmake-utils_use_enable hbci KBANKING)
		$(cmake-utils_use_enable ofx LIBOFX)
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
