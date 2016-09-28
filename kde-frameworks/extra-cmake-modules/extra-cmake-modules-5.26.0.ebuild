# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
KDE_AUTODEPS="false"
KDE_DEBUG="false"
KDE_TEST="false"
inherit kde5 python-any-r1

DESCRIPTION="Extra modules and scripts for CMake"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/extra-cmake-modules"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="doc test"

DEPEND="
	>=dev-util/cmake-2.8.12
	doc? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
	)
	test? (
		$(add_qt_dep qtcore)
		$(add_qt_dep linguist-tools)
	)
"

RDEPEND="
	app-arch/libarchive[bzip2]
"

python_check_deps() {
	has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_HTML_DOCS="$(usex doc)"
		-DBUILD_MAN_DOCS="$(usex doc)"
		-DDOC_INSTALL_DIR="/usr/share/doc/${PF}"
	)

	cmake-utils_src_configure
}

src_test() {
	local myctestargs=(
		-E "(ECMToolchainAndroidTest|KDEInstallDirsTest.relative_or_absolute_usr)"
	)

	kde5_src_test
}
