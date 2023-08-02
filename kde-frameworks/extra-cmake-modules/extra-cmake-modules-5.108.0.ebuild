# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
QTMIN=5.15.9
inherit cmake frameworks.kde.org python-any-r1

DESCRIPTION="Extra modules and scripts for CMake"
HOMEPAGE="https://invent.kde.org/frameworks/extra-cmake-modules"

LICENSE="BSD"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv x86"
IUSE="doc test"

RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
		>=dev-qt/qthelp-${QTMIN}:5
	)
	test? (
		>=dev-qt/linguist-tools-${QTMIN}:5
		>=dev-qt/qtcore-${QTMIN}:5
	)
"
RDEPEND="
	app-arch/libarchive[bzip2]
"

PATCHES=(
	"${FILESDIR}/${PN}-5.49.0-no-fatal-warnings.patch"
	"${FILESDIR}/${PN}-5.93.0-skip-ecm_add_test-early.patch"
	"${FILESDIR}/${PN}-5.93.0-disable-qmlplugindump.patch"
)

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	# Requires PyQt5, bug #680256
	sed -i -e "/^if(NOT SIP_Qt5Core_Mod_FILE)/s/NOT SIP_Qt5Core_Mod_FILE/TRUE/" \
		tests/CMakeLists.txt || die "failed to disable GenerateSipBindings tests"
}

src_configure() {
	local mycmakeargs=(
		-DDOC_INSTALL_DIR=/usr/share/doc/"${PF}"
		-DBUILD_QTHELP_DOCS=$(usex doc)
		-DBUILD_HTML_DOCS=$(usex doc)
		-DBUILD_MAN_DOCS=$(usex doc)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	# ECMToolchainAndroidTest passes but then breaks src_install
	# ECMPoQmToolsTest is broken, bug #627806
	# KDEFetchTranslations can not possibly succeed in releases, bug #764953
	# possible race condition with multiple jobs, bug #701854
	local myctestargs=(
		-j1
		-E "(ECMToolchainAndroidTest|ECMPoQmToolsTest|KDEFetchTranslations)"
	)

	cmake_src_test
}
