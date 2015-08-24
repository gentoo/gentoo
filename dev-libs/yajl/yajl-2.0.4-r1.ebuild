# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit base cmake-multilib

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="https://lloyd.github.com/yajl/"
SRC_URI="https://github.com/lloyd/yajl/tarball/${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${PN}-fix_static_linking.patch
)

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/lloyd-${PN}-* "${S}"
}

src_test() {
	emake -C ${CMAKE_BUILD_DIR} test
}
