# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libhubbub/libhubbub-0.3.0-r1.ebuild,v 1.2 2014/11/15 12:47:57 xmw Exp $

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.2
inherit netsurf

DESCRIPTION="HTML5 compliant parsing library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/hubbub/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k-mint"
IUSE="doc test"

RDEPEND=">=dev-libs/libparserutils-0.2.0-r1[static-libs?,${MULTILIB_USEDEP}]
	!net-libs/hubbub"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lang/perl
		>=dev-libs/json-c-0.10-r1[${MULTILIB_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${P}-glibc2.20.patch )
DOCS=( README docs/{Architecture,Macros,Todo,Treebuilder,Updated} )

#RESTRICT=test
