# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
QTMIN=6.6.2
inherit ecm frameworks.kde.org python-single-r1

DESCRIPTION="Framework based on Gettext for internationalizing user interface text"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-qt/qtdeclarative-${QTMIN}:6
	sys-devel/gettext
	virtual/libintl
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[concurrent] )
"
RDEPEND="${COMMON_DEPEND}
	app-text/iso-codes
"

CMAKE_SKIP_TESTS=(
	# bug 876496
	kcatalogtest
	# requires LANG fr_CH. bugs 823816
	kcountrytest
	kcountrysubdivisiontest
)

pkg_setup() {
	ecm_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	ecm_src_configure
}
