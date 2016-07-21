# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs eutils

DESCRIPTION="Indexes and searches Maildir/MH folders"
HOMEPAGE="http://www.rpcurnow.force9.co.uk/mairix/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	gnus? ( mirror://gentoo/${P}-gnus-marks-propagation.patch.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-macos"

IUSE="zlib bzip2 gnus"

RDEPEND="zlib? ( sys-libs/zlib )
	bzip2? ( app-arch/bzip2 )"

DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

# Fail on various locales
RESTRICT="test"

src_prepare() {
	# econf would fail with unknown options.
	# Now it only prints "Unrecognized option".
	sed -i -e "/^[[:space:]]*bad_options=yes/d" "${S}"/configure || die "sed failed"

	# Add support for gnus marks propagation (bug #274578)
	use gnus && epatch "${WORKDIR}"/${P}-gnus-marks-propagation.patch
}

src_configure() {
	tc-export CC
	econf \
		$(use_enable zlib gzip-mbox) \
		$(use_enable bzip2 bzip-mbox)
}

src_install() {
	dobin mairix
	doman mairix.1 mairixrc.5
	dodoc NEWS README dotmairixrc.eg
}
