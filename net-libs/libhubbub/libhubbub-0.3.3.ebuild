# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.5
inherit netsurf

DESCRIPTION="HTML5 compliant parsing library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/hubbub/"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~m68k-mint"
IUSE="doc test"

RDEPEND=">=dev-libs/libparserutils-0.2.1-r1[static-libs?,${MULTILIB_USEDEP}]
	!net-libs/hubbub"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lang/perl
		>=dev-libs/json-c-0.10-r1[${MULTILIB_USEDEP}] )"

DOCS=( README docs/{Architecture,Macros,Todo,Treebuilder,Updated} )

#RESTRICT=test
