# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit meson-multilib python-any-r1

DESCRIPTION="C++ JSON reader and writer"
HOMEPAGE="https://github.com/open-source-parsers/jsoncpp/"
SRC_URI="
	https://github.com/open-source-parsers/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="|| ( public-domain MIT )"
SLOT="0/26"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	doc? ( app-text/doxygen )
"

multilib_src_configure() {
	local emesonargs=(
		# Follow Debian, Ubuntu, Arch convention for headers location
		# bug #452234
		--includedir include/jsoncpp
		-Dtests=$(usex test true false)
	)
	meson_src_configure
}

src_compile() {
	meson-multilib_src_compile

	if use doc; then
		echo "${PV}" > version || die
		"${EPYTHON}" doxybuild.py --doxygen="${EPREFIX}"/usr/bin/doxygen || die
		HTML_DOCS=( dist/doxygen/jsoncpp*/. )
	fi
}

multilib_src_test() {
	# increase test timeout due to failures on slower hardware
	meson_src_test -t 2
}

multilib_src_install() {
	meson_install
	# https://bugs.gentoo.org/941642
	rm -r "${ED}/usr/$(get_libdir)/cmake" || die
}
