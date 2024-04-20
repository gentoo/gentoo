# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multibuild

DESCRIPTION="KDAB's helper class for single-instance policy applications"
HOMEPAGE="https://github.com/KDAB/KDSingleApplication"
SRC_URI="https://github.com/KDAB/KDSingleApplication/releases/download/v${PV}/kdsingleapplication-${PV}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="doc examples test qt6"
RESTRICT="!test? ( test )"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	qt6? (
		dev-qt/qtbase:6[network,widgets]
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		app-text/doxygen[dot]
		dev-qt/qthelp:5
		qt6? (
			dev-qt/qttools:6[assistant]
		)
	)
	examples? (
		dev-util/patchelf
	)
	dev-qt/qttest:5
"

pkg_setup() {
	MULTIBUILD_VARIANTS=( qt5 $(usev qt6) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DINSTALL_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
		)
		if [[ ${MULTIBUILD_VARIANT} == qt6 ]]; then
			mycmakeargs+=(
				-DKDSingleApplication_DOCS=OFF
				-DKDSingleApplication_EXAMPLES=OFF
				-DKDSingleApplication_QT6=ON
				-DKDSingleApplication_TESTS=OFF
			)
		else
			mycmakeargs+=(
				-DKDSingleApplication_DOCS=$(usex doc)
				-DKDSingleApplication_EXAMPLES=$(usex examples)
				-DKDSingleApplication_QT6=OFF
				-DKDSingleApplication_TESTS=$(usex test)
			)
		fi
		cmake_src_configure
	}
	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	mytest() {
		[[ ${MULTIBUILD_VARIANT} == qt5 ]] && cmake_src_test
	}
	multibuild_foreach_variant mytest
}

src_install() {
	myinstall() {
		cmake_src_install
		if [[ ${MULTIBUILD_VARIANT} == qt5 ]]; then
			rm -rf "${BUILD_DIR}"/docs/api/html/examples || die
			use doc && HTML_DOCS="${BUILD_DIR}/docs/api/html/*"
			if use examples; then
				patchelf --remove-rpath "${BUILD_DIR}"/bin/widgetsingleapplication || die
				dobin "${BUILD_DIR}"/bin/widgetsingleapplication
			fi
		fi
	}
	multibuild_foreach_variant myinstall
	einstalldocs
}
