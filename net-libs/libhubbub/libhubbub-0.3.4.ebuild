# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.6
inherit netsurf

DESCRIPTION="HTML5 compliant parsing library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/hubbub/"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~m68k-mint"
IUSE="doc test"

RDEPEND=">=dev-libs/libparserutils-0.2.1-r1[static-libs?,${MULTILIB_USEDEP}]
	!net-libs/hubbub"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lang/perl
		>=dev-libs/json-c-0.10-r1[${MULTILIB_USEDEP}] )"

DOCS=( README docs/{Architecture,Macros,Todo,Treebuilder,Updated} )

src_prepare() {
	sed -e '1i#pragma GCC diagnostic ignored "-Wimplicit-fallthrough"' \
		-i test/tree2.c || die

	netsurf_src_prepare
}
