# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib flag-o-matic

DESCRIPTION="Bind sockets to privileged ports without root"
HOMEPAGE="http://www.chiark.greenend.org.uk/ucgi/~ian/git/authbind.git/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${P}-respect-flags.patch"
}

src_configure() {
	sed -i \
		-e "s|^prefix=.*|prefix=/usr|" \
		-e "s|^lib_dir=.*|lib_dir=\$(prefix)/$(get_libdir)|" \
		-e "s|^libexec_dir=.*|libexec_dir=\$(prefix)/libexec/authbind|" \
		-e "s|^SHARED_LDFLAGS=.*|SHARED_LDFLAGS=$(raw-ldflags)|" \
		Makefile || die "sed failed"

	sed -i \
		-e 's|/usr/lib|/usr/libexec|' \
		authbind-helper.8 || die "sed failed"
}

src_install() {
	dobin authbind
	doman authbind.1 authbind-helper.8

	ln -s libauthbind.so.* libauthbind.so.$(awk -F= '/MAJOR=/ { print $2 }' < Makefile)
	dolib.so libauthbind.so*

	exeinto /usr/libexec/authbind
	exeopts -m4755
	doexe helper

	keepdir /etc/authbind/by{addr,port,uid}

	dodoc debian/changelog
}
