# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="High-Efficiency AAC (AAC+) Encoder"
HOMEPAGE="http://teknoraver.net/software/mp4tools/"
SRC_URI="https://ppa.launchpad.net/teknoraver/ppa/ubuntu/pool/main/a/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-libs/fftw:3.0"
DEPEND="${RDEPEND}
	sys-apps/sed"

# 3GPP patenting issues
RESTRICT="mirror test"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch

	# Fix linking order (bug #393137)
	epatch "${FILESDIR}"/${P}-libm.patch

	sed \
		-e 's:LDFLAGS:LIBRARIES:g' \
		-e 's:$(CC) $(CFLAGS):$(CC) $(LDFLAGS) $(CFLAGS):' \
		-e 's:ar r:$(AR) r:g' \
		-e 's:strip:true:' \
		-e 's:-O3 -ftree-vectorize::' \
		-i configure Makefile lib*/Makefile || die "sed failed"
}

src_configure() {
	tc-export AR CC
	./configure || die "./configure failed"
}

src_compile() {
	emake EXTRACFLAGS="${CFLAGS}"
}

src_install() {
	emake INSTDIR="${D}/usr" install
	doman ${PN}.1
	dodoc debian/changelog
}
