# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit netsurf

DESCRIPTION="HTML5 compliant parsing library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/hubbub/"
SRC_URI="http://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="debug doc static-libs test"

RDEPEND="<dev-libs/libparserutils-0.2
	!net-libs/libhubbub"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	virtual/libiconv
	doc? ( app-doc/doxygen )
	test? ( dev-lang/perl
		dev-libs/json-c )"

RESTRICT=test

PATCHES=( "${FILESDIR}"/${P}-glibc-2.20.patch )

src_install() {
	netsurf_src_install

	dodoc README docs/{Architecture,Macros,Todo,Treebuilder,Updated}
	use doc && dohtml build/docs/html/*
}
