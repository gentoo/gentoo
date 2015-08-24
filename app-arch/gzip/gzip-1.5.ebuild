# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic unpacker

DESCRIPTION="Standard GNU compressor"
HOMEPAGE="https://www.gnu.org/software/gzip/"
SRC_URI="mirror://gnu-alpha/gzip/${P}.tar.xz
	mirror://gnu/gzip/${P}.tar.xz
	mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="nls pic static"

RDEPEND=""
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpacker
	cd "${S}"
	#epatch "${FILESDIR}"/${PN}-1.3.5-rsync.patch
	epatch "${FILESDIR}"/${PN}-1.3.8-install-symlinks.patch
}

src_compile() {
	use static && append-flags -static
	# avoid text relocation in gzip
	use pic && export DEFS="NO_ASM"
	econf || die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc ChangeLog NEWS README THANKS TODO
	docinto txt
	dodoc algorithm.doc gzip.doc

	# keep most things in /usr, just the fun stuff in /
	dodir /bin
	mv "${D}"/usr/bin/{gunzip,gzip,uncompress,zcat} "${D}"/bin/ || die
	sed -e 's:/usr::' -i "${D}"/bin/gunzip || die
}
