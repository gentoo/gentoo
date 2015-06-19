# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kig/kig-4.14.3.ebuild,v 1.1 2015/06/04 18:44:42 kensington Exp $

EAPI=5

KDE_HANDBOOK="optional"
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 kde4-base

DESCRIPTION="KDE Interactive Geometry tool"
HOMEPAGE="http://www.kde.org/applications/education/kig http://edu.kde.org/kig"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug scripting"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	scripting? ( >=dev-libs/boost-1.48:=[python,${PYTHON_USEDEP}] )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-4.12.0-boostpython.patch" )

pkg_setup() {
	python-single-r1_pkg_setup
	kde4-base_pkg_setup
}

src_prepare() {
	kde4-base_src_prepare

	python_fix_shebang .
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package scripting BoostPython)
	)

	kde4-base_src_configure
}
