# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Source files of vuln Debian keys"
HOMEPAGE="http://packages.qa.debian.org/o/openssh-blacklist.html"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""

DEPEND=""

maint_pkg_create() {
	wget http://cvsweb.openwall.com/cgi/cvsweb.cgi/~checkout~/Owl/packages/openssh/blacklist-encode.c -O "${FILESDIR}"/blacklist-encode.c
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}"/blacklist-encode.c . || die
}

src_compile() {
	emake \
		CC="$(tc-getBUILD_CC)" \
		CFLAGS="${BUILD_CFLAGS}" \
		CPPFLAGS="${BUILD_CPPFLAGS}" \
		LDFLAGS="${BUILD_LDFLAGS}" \
		blacklist-encode || die
	cat [DR]SA-* | ./blacklist-encode 6 > blacklist
}

src_install() {
	insinto /etc/ssh
	doins blacklist || die
}
