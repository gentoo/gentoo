# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic

DESCRIPTION="utilities to access MS-DOS disks from Unix without mounting them"
HOMEPAGE="https://www.gnu.org/software/mtools/ https://savannah.gnu.org/projects/mtools"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x64-solaris"
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
DEPEND="${RDEPEND}
	sys-apps/texinfo"
# texinfo is required because we patch mtools.texi
# drop it when mtools-4.0.18-locking.patch is no longer applied

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.18-locking.patch # https://crbug.com/508713
	"${FILESDIR}"/${PN}-4.0.18-attr.patch # https://crbug.com/644387
	"${FILESDIR}"/${PN}-4.0.18-memset.patch
)

src_prepare() {
	default

	# Don't throw errors on existing directories
	sed -i -e "s:mkdir:mkdir -p:" mkinstalldirs || die
}

src_configure() {
	# 447688
	use !elibc_glibc && use !elibc_musl && append-libs "-liconv"
	econf \
		--sysconfdir="${EPREFIX%/}"/etc/mtools \
		$(use_with X x)
}

src_install() {
	local -a DOCS=( README* Release.notes )
	default

	insinto /etc/mtools
	doins mtools.conf

	# default is fine
	sed -i -e '/^SAMPLE FILE$/s:^:#:' "${ED%/}"/etc/mtools/mtools.conf || die
}
