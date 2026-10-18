# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
QTMIN=6.10.1
inherit ecm frameworks.kde.org locale-utils python-single-r1

DESCRIPTION="Framework based on Gettext for internationalizing user interface text"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-qt/qtbase-${QTMIN}:6[widgets]
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
	# flaky, bug 948895
	ki18n-klocalizedstringtest
)

src_configure() {
	local mycmakeargs=(
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	ecm_src_configure
}

src_test() {
	# bug #823816
	local -x LOCPATH
	elocale_gen fr_CH.UTF-8
	# LC_MESSAGES would take precedence over the LANG set by the tests
	local -x LC_MESSAGES=
	ecm_src_test
}
