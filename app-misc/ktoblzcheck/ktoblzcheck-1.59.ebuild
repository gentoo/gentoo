# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

DATA_TIMESTAMP="20250515"

inherit cmake python-single-r1

DESCRIPTION="A library to check account numbers and bank codes of German banks."
HOMEPAGE="https://ktoblzcheck.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="doc python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	app-misc/ktoblzcheck-data
	dev-db/sqlite
	net-misc/curl
	python? ( ${PYTHON_DEPS} )
	"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-text/doxygen )
	"

PATCHES=(
	"${FILESDIR}/${PN}-cmake-CMP0153.patch"
	"${FILESDIR}/${PN}-fix-python-libdir.patch"
	)

DOCS=( AUTHORS ChangeLog NEWS README.md )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Install API HTML doc to the right place
	sed -e "s@doc/ktoblzcheck/api@doc/${P}/api@" \
		-i doc/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package doc Doxygen)
		$(cmake_use_find_package python Python3)
	)

	if use python; then
		local mycmakeargs+=(
			-DPython_SITEARCH="$(python_get_sitedir)"
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}
