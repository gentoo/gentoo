# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Lightweight HTTP server for static content"
SRC_URI="http://dl.bytesex.org/releases/${PN}/${P}.tar.gz"
HOMEPAGE="http://linux.bytesex.org/misc/webfs.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~arm-linux ~x86-linux"
IUSE="libressl ssl threads"

DEPEND="
	ssl?  (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)"

RDEPEND="${DEPEND}
	app-misc/mime-types"

src_prepare() {
	epatch "${FILESDIR}/${P}-Variables.mk-dont-strip-binaries-on-install.patch"
	epatch "${FILESDIR}/${P}-CVE-2013-0347.patch"
	sed -e "s:/etc/mime.types:${EPREFIX}\\0:" -i GNUmakefile || die "sed failed"
}

src_compile() {
	local myconf
	use ssl || myconf="${myconf} USE_SSL=no"
	use threads && myconf="${myconf} USE_THREADS=yes"

	emake prefix="${EPREFIX}/usr" ${myconf}
}

src_install() {
	local myconf
	use ssl || myconf="${myconf} USE_SSL=no"
	use threads && myconf="${myconf} USE_THREADS=yes"
	einstall ${myconf} mandir="${ED}/usr/share/man"
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	dodoc README
}

pkg_preinst() {
	# Fix existing log permissions for bug #458892.
	chmod 0600 "${EROOT}/var/log/webfsd.log" 2>/dev/null
}
