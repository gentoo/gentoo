# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Daemon for the Linux Device Filesystem"
HOMEPAGE="http://www.atnf.csiro.au/~rgooch/linux/"
SRC_URI="ftp://ftp.atnf.csiro.au/pub/people/rgooch/linux/daemons/devfsd/devfsd-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="<sys-kernel/linux-headers-2.6.18"
RDEPEND=""

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-kernel-2.5.patch
	epatch "${FILESDIR}"/${P}-pic.patch
	epatch "${FILESDIR}"/${P}-no-nis.patch

	use elibc_uclibc || append-cppflags -DHAVE_NIS
	sed -i \
		-e "s:-O2:${CFLAGS}:g" \
		-e 's:/usr/man:/usr/share/man:' \
		-e 's:/usr/src/linux:.:' \
		-e '32,34d;11,16d' -e '6c\' \
		-e 'DEFINES	:= -DLIBNSL="\\"/lib/libnsl.so.1\\""' \
		-e 's:install -s:install:' \
		GNUmakefile
	use elibc_uclibc && sed -e 's|libnsl.so.1|libnsl.so.0|' -i GNUmakefile
	tc-export CC
}

src_install() {
	dodir /sbin /usr/share/man /etc
	emake PREFIX="${D}" install
	dodoc devfsd.conf INSTALL

	keepdir /etc/devfs.d
	insinto /etc
	doins "${FILESDIR}"/devfsd.conf

	insinto /lib/rcscripts/addons
	doins "${FILESDIR}"/devfs-{start,stop}.sh
}

pkg_postinst() {
	echo
	einfo "You may wish to read the Gentoo Linux Device Filesystem Guide,"
	einfo "which can be found online at:"
	einfo "    https://wwwold.gentoo.org/doc/en/devfs-guide.xml"
	echo
}
