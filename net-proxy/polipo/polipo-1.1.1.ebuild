# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/polipo/polipo-1.1.1.ebuild,v 1.3 2015/01/12 10:38:00 ago Exp $

EAPI="5"

if [[ ${PV} == "9999" ]] ; then
	_GIT=git-r3
	EGIT_REPO_URI="https://github.com/jech/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://www.pps.jussieu.fr/~jch/software/files/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

inherit ${_GIT} toolchain-funcs user

DESCRIPTION="A caching web proxy"
HOMEPAGE="http://www.pps.jussieu.fr/~jch/software/polipo/"
LICENSE="MIT GPL-2"
SLOT="0"

DEPEND="sys-apps/texinfo"
RDEPEND=""

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/cache/${PN} ${PN}
}

src_compile() {
	tc-export CC
	emake PREFIX=/usr "CDEBUGFLAGS=${CFLAGS}" all
}

src_install() {
	einstall PREFIX=/usr MANDIR=/usr/share/man INFODIR=/usr/share/info "TARGET=${D}"

	newinitd "${FILESDIR}/${PN}.initd-2" ${PN}
	insinto /etc/${PN} ; doins "${FILESDIR}/config"
	exeinto /etc/cron.weekly ; newexe "${FILESDIR}/${PN}.crond-2" ${PN}

	dodoc CHANGES README
	dohtml html/*
}

pkg_postinst() {
	einfo "Do not forget to read the manual."
	einfo "Change the config file in /etc/${PN} to suit your needs."
	einfo ""
	einfo "Polipo OpenRC init scripts can now be multiplexed:"
	einfo "1. create /etc/${PN}/config.foo"
	einfo "2. symlink /etc/init.d/{${PN}.foo -> ${PN}}"
	einfo "3. make sure all instances use unique ip:port pair and cachedir, if any"
}
