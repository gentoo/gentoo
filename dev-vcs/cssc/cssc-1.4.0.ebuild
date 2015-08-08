# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="The GNU Project's replacement for SCCS"
SRC_URI="mirror://gnu/${PN}/${P^^}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/cssc/"
SLOT="0"
LICENSE="GPL-3"

KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test valgrind"

DEPEND="
	test? ( valgrind? ( dev-util/valgrind ) )
"

DOCS=( AUTHORS ChangeLog NEWS README )

S="${WORKDIR}/${P^^}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.3.0-gcc47.patch \
		"${FILESDIR}"/${P}-config.patch \
		"${FILESDIR}"/${P}-m4.patch \
		"${FILESDIR}"/${P}-test-large.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use test && use_with valgrind) \
		--enable-binary
}

src_test() {
	if [[ ${froobUID} = 0 ]]; then
		einfo "The test suite can not be run as root"
	else
		emake check
	fi
}
