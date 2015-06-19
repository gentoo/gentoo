# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/yajl/yajl-1.0.11-r1.ebuild,v 1.3 2014/06/22 10:01:32 mgorny Exp $

EAPI=5

inherit cmake-multilib vcs-snapshot

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="http://lloyd.github.com/yajl/"
SRC_URI="http://github.com/lloyd/yajl/tarball/${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"

IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-fix_tests.patch

	cmake-utils_src_prepare
}

multilib_src_test() {
	emake test
}
