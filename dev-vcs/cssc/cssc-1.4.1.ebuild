# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

CSSC_PN="${PN^^}"
CSSC_P="${CSSC_PN}-${PV}"

DESCRIPTION="The GNU Project's replacement for SCCS"
HOMEPAGE="https://www.gnu.org/software/cssc/"
SRC_URI="mirror://gnu/${PN}/${CSSC_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

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
	# Valgrind is only used for tests
	econf \
		--without-valgrind \
		--enable-binary
}

src_test() {
	if [[ ${UID} = 0 ]]; then
		einfo "The test suite can not be run as root"
	else
		emake check
	fi
}
