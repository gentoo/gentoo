# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit flag-o-matic eutils

DESCRIPTION="utilities to access MS-DOS disks from Unix without mounting them"
HOMEPAGE="https://www.gnu.org/software/mtools/ https://savannah.gnu.org/projects/mtools"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="X elibc_glibc"

DEPEND="
	!elibc_glibc? ( virtual/libiconv )
	X? (
		x11-libs/libICE
		x11-libs/libXau
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXt
	)"
RDEPEND="${DEPEND}"

src_prepare() {
	# Don't throw errors on existing directories
	sed -i -e "s:mkdir:mkdir -p:" mkinstalldirs || die

	epatch "${FILESDIR}"/${P}-locking.patch # https://crbug.com/508713
}

src_configure() {
	# 447688
	use elibc_glibc || append-libs iconv
	econf \
		--sysconfdir="${EPREFIX}"/etc/mtools \
		$(use_with X x)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README* Release.notes

	insinto /etc/mtools
	doins mtools.conf
	# default is fine
	sed -i -e '/^SAMPLE FILE$/s:^:#:' "${ED}"/etc/mtools/mtools.conf || die
}
