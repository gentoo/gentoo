# Copyright 2001-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=411fb3c4dc54b6aaea00f034d6c5396de5daa474
MY_PN=${PN}-source-mirror
SIAPP_PN=SingleApplication
SIAPP_PV=3.5.3
SIAPP_P=${SIAPP_PN}-${SIAPP_PV}
inherit cmake qmake-utils xdg

DESCRIPTION="Qt application to design electric diagrams"
HOMEPAGE="https://qelectrotech.org/"

if [[ ${PV} == *9999* ]]; then
	EGIT_BRANCH="qt6-cmake" # TODO: Track upstream for merging this to git master!
	EGIT_REPO_URI="https://github.com/qelectrotech/qelectrotech-source-mirror"
	inherit git-r3
elif [[ -n ${COMMIT} ]]; then
	SRC_URI="https://github.com/${PN}/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${COMMIT}"
else
	MY_PV=${PV/%0/.0}
	SRC_URI="https://github.com/${PN}/${MY_PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/qet-${MY_PV}"
fi
SRC_URI+=" https://github.com/itay-grudev/${SIAPP_PN}/archive/refs/tags/v${SIAPP_PV}.tar.gz -> ${SIAPP_P}.tar.gz"

LICENSE="CC-BY-3.0 GPL-2+"
SLOT="0"
if [[ ${PV} == *9999* ]]; then
	KEYWORDS="~amd64 ~arm64 ~x86"
fi
IUSE="doc"

RDEPEND="
	dev-db/sqlite:3
	dev-qt/qtbase:6[concurrent,gui,network,sql,sqlite,widgets,xml]
	dev-qt/qtsvg:6
	kde-frameworks/kcoreaddons:6
	kde-frameworks/kwidgetsaddons:6
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
		dev-qt/qttools:6[assistant]
	)
"

DOCS=( CREDIT ChangeLog README )

PATCHES=(
	"${FILESDIR}"/${PN}-0.90_pre20250820-cmake.patch
)

src_prepare() {
	cmake_src_prepare
	sed -e "/QHG_LOCATION/s:\".*\":""$(qt6_get_libexecdir)/qhelpgenerator"":" -i Doxyfile || die
}

src_configure() {
	local mycmakeargs=(
		-DPACKAGE_TESTS=OFF
		-DGIT_COMMIT_SHA=${COMMIT}
		-DFETCHCONTENT_SOURCE_DIR_SINGLEAPPLICATION="${WORKDIR}/${SIAPP_P}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use doc; then
		doxygen Doxyfile || die
		local HTML_DOCS=( doc/html/. )
	fi

	einstalldocs
}
