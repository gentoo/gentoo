# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils java-pkg-2

DESCRIPTION="Decrypt keys from an AACS source (HD DVD / Blu-Ray)"
HOMEPAGE="http://forum.doom9.org/showthread.php?t=123311"
SRC_URI="http://bluray.beandog.org/aacskeys/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-libs/openssl[-bindist]"
DEPEND=">=virtual/jdk-1.6
	${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-aacskeys-makefile.patch"
	epatch "${FILESDIR}/${P}-libaacskeys-makefile.patch"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin bin/linux/aacskeys || die
	dolib lib/linux/libaacskeys.so || die
	dodoc HostKeyCertificate.txt ProcessingDeviceKeysSimple.txt \
		README.txt || die
}
