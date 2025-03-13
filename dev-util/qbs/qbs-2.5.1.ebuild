# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit cmake flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Modern build tool for software projects"
HOMEPAGE="https://doc.qt.io/qbs/"
SRC_URI="https://download.qt.io/official_releases/qbs/${PV}/${PN}-src-${PV}.tar.gz"
S=${WORKDIR}/${PN}-src-${PV}

LICENSE="|| ( LGPL-2.1 LGPL-3 ) Boost-1.0 BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,gui,network,widgets,xml]
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		$(python_gen_any_dep '
			dev-python/beautifulsoup4[${PYTHON_USEDEP}]
			dev-python/lxml[${PYTHON_USEDEP}]
		')
		dev-qt/qttools:6[assistant,qdoc]
	)
"

CMAKE_SKIP_TESTS=(
	# QBS does not inherit toolchain/flags knowledge from cmake, and
	# while can use ${BUILD_DIR}/bin/qbs-config to improve this it
	# remains very fickle and will fail in varied ways with clang,
	# musl, -native-symlinks, and libc++. After consideration it feels
	# not worth worrying about affected tests here (even if notable).
	tst_api
	tst_blackbox # also skips blackbox-* (intended)
	tst_language
)

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.1-qtver.patch
	"${FILESDIR}"/${PN}-2.4.1-ldconfig.patch
)

python_check_deps() {
	# _find_python_module in cmake/QbsDocumentation.cmake
	python_has_version "dev-python/beautifulsoup4[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/lxml[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_configure() {
	# temporary workaround for musl-1.2.4 (bug #906929), this ideally
	# needs fixing in qtbase as *64 usage comes from its headers' macros
	use elibc_musl && append-lfs-flags

	# tests build failure w/ gcc:14 + -O3 (bug #933187, needs looking into)
	use test && tc-is-gcc && [[ $(gcc-major-version) -ge 14 ]] &&
		replace-flags -O3 -O2

	local mycmakeargs=(
		-DQBS_DOC_INSTALL_DIR="${EPREFIX}"/usr/share/doc/${PF}
		-DQBS_INSTALL_HTML_DOCS=$(usex doc)
		-DQBS_INSTALL_MAN_PAGE=yes
		-DQBS_INSTALL_QCH_DOCS=$(usex doc)
		-DQBS_LIB_INSTALL_DIR="$(get_libdir)"
		-DQT_VERSION_MAJOR=6 #931596
		-DWITH_TESTS=$(usex test)
		-DWITH_UNIT_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_install() {
	local DOCS=( README.md changelogs )
	cmake_src_install

	use !test || rm -- "${ED}"/usr/bin/{tst_*,qbs_*,clang-format-test} || die

	docompress -x /usr/share/doc/${PF}/qbs.qch
}
