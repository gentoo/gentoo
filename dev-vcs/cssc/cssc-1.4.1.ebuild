# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

CSSC_PN="${PN^^}"
CSSC_P="${CSSC_PN}-${PV}"

DESCRIPTION="The GNU Project's replacement for SCCS"
SRC_URI="mirror://gnu/${PN}/${CSSC_P}.tar.gz"
HOMEPAGE="https://www.gnu.org/software/cssc/"
SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

IUSE="test valgrind"
RESTRICT="!test? ( test )"
DEPEND="
	test? ( valgrind? ( dev-util/valgrind ) )
"
DOCS=( AUTHORS ChangeLog NEWS README )
PATCHES=(
	"${FILESDIR}"/${PN}-1.4.1-m4.patch
)
S=${WORKDIR}/${CSSC_P}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use test && use_with valgrind) \
		--enable-binary
}

src_test() {
	if [[ ${UID} = 0 ]]; then
		einfo "The test suite can not be run as root"
	else
		emake check
	fi
}
