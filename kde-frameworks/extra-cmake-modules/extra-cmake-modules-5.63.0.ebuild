# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )
ECM_KDEINSTALLDIRS="false"
KDE_AUTODEPS="false"
KDE_DEBUG="false"
KDE_QTHELP="false"
KDE_TEST="false"
inherit kde5 python-any-r1

DESCRIPTION="Extra modules and scripts for CMake"
HOMEPAGE="https://cgit.kde.org/extra-cmake-modules.git"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd"
IUSE="doc test"

BDEPEND="
	doc? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
		$(add_qt_dep qthelp)
	)
	test? (
		$(add_qt_dep qtcore)
		$(add_qt_dep linguist-tools)
	)
"
RDEPEND="
	app-arch/libarchive[bzip2]
"

PATCHES=( "${FILESDIR}/${PN}-5.49.0-no-fatal-warnings.patch" )

python_check_deps() {
	has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	kde5_src_prepare
	# Requires PyQt5, bug #680256
	sed -i -e "/^if(NOT SIP_Qt5Core_Mod_FILE)/s/NOT SIP_Qt5Core_Mod_FILE/TRUE/" \
		tests/CMakeLists.txt || die "failed to disable GenerateSipBindings tests"
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_QTHELP_DOCS=$(usex doc)
		-DBUILD_HTML_DOCS=$(usex doc)
		-DBUILD_MAN_DOCS=$(usex doc)
		-DDOC_INSTALL_DIR=/usr/share/doc/"${PF}"
	)

	kde5_src_configure
}

src_test() {
	# ECMToolchainAndroidTest passes but then breaks src_install
	# ECMPoQmToolsTest is broken, bug #627806
	local myctestargs=(
		-E "(ECMToolchainAndroidTest|ECMPoQmToolsTest)"
	)

	kde5_src_test
}
