# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/grantlee/grantlee-0.4.0.ebuild,v 1.6 2015/02/23 11:02:47 ago Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="C++ string template engine based on the Django template system"
HOMEPAGE="http://www.gitorious.org/grantlee/pages/Home"
SRC_URI="http://downloads.grantlee.org/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="debug doc test"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4
"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.7.6.1[dot] )
	test? ( dev-qt/qttest:4 )
"

# Some tests fail
RESTRICT="test"

DOCS=( AUTHORS CHANGELOG GOALS README )
PATCHES=(
	"${FILESDIR}/${PN}-0.3.0-nonfatal-warnings.patch"
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build test TESTS)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use doc && cmake-utils_src_compile docs
}

src_install() {
	use doc && HTML_DOCS=( "${BUILD_DIR}/apidox/" )

	cmake-utils_src_install
}
