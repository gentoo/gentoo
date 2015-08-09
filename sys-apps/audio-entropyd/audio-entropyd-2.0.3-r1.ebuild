# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils systemd toolchain-funcs

DESCRIPTION="Audio-entropyd generates entropy-data for the /dev/random device"
HOMEPAGE="http://www.vanheusden.com/aed/"
SRC_URI="http://www.vanheusden.com/aed/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-entropyd )
	media-sound/alsa-utils
	media-libs/alsa-lib"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.0.1-uclibc.patch" \
		"${FILESDIR}/${PN}-2.0.1-ldflags.patch"
	sed -i -e "s:^OPT_FLAGS=.*:OPT_FLAGS=${CFLAGS}:" \
		-e "/^WARNFLAGS/s: -g::" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dosbin audio-entropyd
	dodoc README TODO
	systemd_dounit "${FILESDIR}/${PN}.service"
	newinitd "${FILESDIR}/${PN}.init-2" ${PN}
	newconfd "${FILESDIR}/${PN}.conf-2" ${PN}
}
