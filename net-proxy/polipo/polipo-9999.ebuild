# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

if [[ ${PV} == "9999" ]] ; then
	_GIT=git-r3
	EGIT_REPO_URI="https://github.com/jech/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://www.pps.jussieu.fr/~jch/software/files/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit ${_GIT} toolchain-funcs user systemd

DESCRIPTION="A caching web proxy"
HOMEPAGE="http://www.pps.jussieu.fr/~jch/software/polipo/"
LICENSE="MIT GPL-2"
SLOT="0"
IUSE="systemd"

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
	systemd_newunit "${FILESDIR}/${PN}_at.service" "${PN}@.service"
	if ! use systemd; then
		exeinto /etc/cron.weekly ; newexe "${FILESDIR}/${PN}.crond-2" ${PN}
	fi

	dodoc CHANGES README
	dohtml html/*
}

pkg_postinst() {
	elog "Do not forget to read the manual."
	elog "Change the config file in /etc/${PN} to suit your needs."
	elog ""
	elog "Polipo init scripts can now be multiplexed:"
	elog "1. create /etc/${PN}/config.foo"
	elog "2. symlink /etc/init.d/{${PN}.foo -> ${PN}}"
	elog "  a. if you are using OpenRC, symlink /etc/init.d/{${PN}.foo -> ${PN}}"
	elog "  b. if you are using systemd, execute \"systemctl enable polipo@config.foo\""
	elog "3. make sure all instances use unique ip:port pair and cachedir, if any"
}
