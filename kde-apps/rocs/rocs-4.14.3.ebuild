# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE4 interface to work with Graph Theory"
HOMEPAGE="https://www.kde.org/applications/education/rocs
https://edu.kde.org/applications/mathematics/rocs"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	dev-libs/grantlee:0
	dev-qt/qtxmlpatterns:4
"
DEPEND="
	${RDEPEND}
	>=dev-libs/boost-1.49
"

RESTRICT=test
# bug 443752

src_test() {
	local mycmakeargs=(-DKDE4_BUILD_TESTS=ON)
	cmake-utils_src_configure
	kde4-base_src_compile

	cd "${BUILD_DIR}"
	emake DESTDIR="${T}/tests" install
	export KDEDIRS="${KDEDIRS}:${T}/tests/${PREFIX}"
	kbuildsycoca4
	ctest || die "tests failed"
}
