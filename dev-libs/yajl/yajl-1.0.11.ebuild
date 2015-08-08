# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit cmake-utils

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="http://lloyd.github.com/yajl/"
SRC_URI="http://github.com/lloyd/yajl/tarball/${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86"

IUSE=""

CMAKE_IN_SOURCE_BUILD="1"

src_prepare() {
	cd "${WORKDIR}"/lloyd-${PN}-*
	S=$(pwd)

	epatch "${FILESDIR}"/${PN}-fix_tests.patch
}

src_test() {
	emake test
}
