# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="utilities to access MS-DOS disks from Unix without mounting them"
HOMEPAGE="https://www.gnu.org/software/mtools/ https://savannah.gnu.org/projects/mtools"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="X elibc_glibc"

RDEPEND="
	!elibc_glibc? ( virtual/libiconv )
	X? (
		x11-libs/libICE
		x11-libs/libXau
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}"

src_configure() {
	# 447688
	use !elibc_glibc && use !elibc_musl && append-libs "-liconv"
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/mtools
		$(use_with X x)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	local -a DOCS=( README* Release.notes )
	default

	insinto /etc/mtools
	doins mtools.conf

	# default is fine
	sed -i -e '/^SAMPLE FILE$/s:^:#:' "${ED}"/etc/mtools/mtools.conf || die
}
