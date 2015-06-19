# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/gimps/gimps-27.9-r2.ebuild,v 1.4 2015/03/05 08:32:40 jlec Exp $

EAPI=4

inherit pax-utils systemd

DESCRIPTION="The Great Internet Mersenne Prime Search"
HOMEPAGE="http://mersenne.org/"
SRC_URI="
	amd64? ( ftp://mersenne.org/gimps/p95v${PV/./}.linux64.tar.gz )
	x86? ( ftp://mersenne.org/gimps/p95v${PV/./}.linux32.tar.gz )"

SLOT="0"
LICENSE="GIMPS"
KEYWORDS="-* amd64 x86"
IUSE=""

# Since there are no statically linked binaries for this version of mprime,
# and no static binaries for amd64 in general, we use the dynamically linked
# ones and try to cover the .so deps with the packages listed in RDEPEND.
DEPEND=""
RDEPEND="net-misc/curl"

S="${WORKDIR}"
I="/opt/gimps"

QA_PREBUILT="opt/gimps/mprime"

src_install() {
	dodir ${I} /var/lib/gimps
	pax-mark m mprime
	cp mprime "${D}/${I}"
	fperms a-w "${I}/mprime"
	fowners root:0 "${I}"
	fowners root:0 "${I}/mprime"

	dodoc license.txt readme.txt stress.txt whatsnew.txt undoc.txt

	newinitd "${FILESDIR}/${PN}-26.6-r1-init.d" gimps
	newconfd "${FILESDIR}/${PN}-25.6-conf.d" gimps

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newtmpfilesd "${FILESDIR}/${PN}.tmpfiles" "${PN}.conf"
}

pkg_postinst() {
	echo
	einfo "You can use \`/etc/init.d/gimps start\` to start a GIMPS client in the"
	einfo "background at boot. Have a look at /etc/conf.d/gimps and check some"
	einfo "configuration options."
	einfo
	einfo "If you don't want to use the init script to start gimps, remember to"
	einfo "pass it an additional command line parameter specifying where the data"
	einfo "files are to be stored, e.g.:"
	einfo "   ${I}/mprime -w/var/lib/gimps"
	echo
}

pkg_postrm() {
	echo
	einfo "GIMPS data files were not removed."
	einfo "Remove them manually from /var/lib/gimps/"
	echo
}
