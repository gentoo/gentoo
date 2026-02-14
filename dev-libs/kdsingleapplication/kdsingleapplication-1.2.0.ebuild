# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qmake-utils

DESCRIPTION="KDAB's helper class for single-instance policy applications"
HOMEPAGE="https://github.com/KDAB/KDSingleApplication"
SRC_URI="https://github.com/KDAB/KDSingleApplication/releases/download/v${PV}/kdsingleapplication-${PV}.tar.gz"
S="${WORKDIR}"/KDSingleApplication-${PV}

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"

IUSE="doc examples test"
RESTRICT="!test? ( test )"

DEPEND="dev-qt/qtbase:6[network,widgets]"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		app-text/doxygen[dot]
		dev-qt/qttools:6[assistant]
	)
	examples? ( dev-util/patchelf )
"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DKDSingleApplication_QT6=ON
		-DKDSingleApplication_DOCS=$(usex doc)
		-DKDSingleApplication_EXAMPLES=$(usex examples)
		-DKDSingleApplication_TESTS=$(usex test)
	)
	use doc && mycmakeargs+=(
		-DQHELPGEN_EXECUTABLE="$(qt6_get_libexecdir)/qhelpgenerator"
	)
	cmake_src_configure
}

src_install() {
	if use doc; then
		if use examples; then
			rm -r "${BUILD_DIR}"/docs/api/html/examples || die
		fi
		local HTML_DOCS=( "${BUILD_DIR}"/docs/api/html/. )
	fi
	if use examples; then
		patchelf --remove-rpath "${BUILD_DIR}"/bin/widgetsingleapplication || die
		dobin "${BUILD_DIR}"/bin/widgetsingleapplication
	fi
	cmake_src_install
}
