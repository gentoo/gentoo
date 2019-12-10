# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

# Switch to ^^ when we switch to EAPI=6.
#MY_PN="${PN^^}"
MY_PN="CSSC"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The GNU Project's replacement for SCCS"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"
HOMEPAGE="https://www.gnu.org/software/cssc/"
SLOT="0"
LICENSE="GPL-3"

KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test valgrind"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( valgrind? ( dev-util/valgrind ) )
"

DOCS=( AUTHORS ChangeLog NEWS README )

S="${WORKDIR}/${MY_P}"

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
