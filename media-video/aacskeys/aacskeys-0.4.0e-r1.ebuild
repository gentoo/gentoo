# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils java-pkg-2

DESCRIPTION="Decrypt keys from an AACS source (HD DVD / Blu-Ray)"
HOMEPAGE="http://forum.doom9.org/showthread.php?t=123311"
SRC_URI="http://bluray.beandog.org/aacskeys/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/openssl:0=[-bindist]"
DEPEND=">=virtual/jdk-1.6
	${RDEPEND}"

DOCS=(
	HostKeyCertificate.txt
	ProcessingDeviceKeysSimple.txt
	README.txt
)

PATCHES=(
	"${FILESDIR}/${PN}-0.4.0c-aacskeys-makefile.patch"
	"${FILESDIR}/${PN}-0.4.0c-libaacskeys-makefile.patch"
)

# overriding src_* functions from java-pkg-2 eclass.
src_prepare() {
	default
}

src_compile() {
	emake
}

src_install() {
	dobin bin/linux/aacskeys
	dolib lib/linux/libaacskeys.so
	einstalldocs
}
