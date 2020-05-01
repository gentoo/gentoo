# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit meson python-any-r1

EGIT_COMMIT="90ca694e4697497a8c2bc8c60a9c9f89e7290a10"
DESCRIPTION="C++ JSON reader and writer"
HOMEPAGE="https://github.com/open-source-parsers/jsoncpp"
SRC_URI="
	https://github.com/open-source-parsers/${PN}/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

LICENSE="|| ( public-domain MIT )"
SLOT="0/23"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )"
RDEPEND=""

src_configure() {
	local emesonargs=(
		# Follow Debian, Ubuntu, Arch convention for headers location
		# bug #452234
		--includedir include/jsoncpp
		-Dtests=$(usex test true false)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile

	if use doc; then
		echo "${PV}" > version || die
		"${EPYTHON}" doxybuild.py --doxygen="${EPREFIX}"/usr/bin/doxygen || die
		HTML_DOCS=( dist/doxygen/jsoncpp*/. )
	fi
}
