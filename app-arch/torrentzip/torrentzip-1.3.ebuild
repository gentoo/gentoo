# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake python-any-r1

MY_P="trrntzip-${PV}"
DESCRIPTION="Create identical zip archives over multiple systems"
HOMEPAGE="https://github.com/0-wiz-0/trrntzip"
SRC_URI="https://github.com/0-wiz-0/trrntzip/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+ ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		${RDEPEND}
		${PYTHON_DEPS}
		>=dev-util/nihtest-1.5.0
	)
"

DOCS=(AUTHORS NEWS.md README.md)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	if use test; then
		local mycmakeargs=( -DPYTHONBIN="${EPYTHON}" )
	else
		local mycmakeargs=( -DRUN_REGRESS=NO )
	fi
	cmake_src_configure
}
