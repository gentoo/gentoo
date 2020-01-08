# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit eutils perl-module

PATCHVER=0.2
MY_PN=${PN/b/B}
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_PN}
DESCRIPTION="Bastille-Linux is a security hardening tool"
HOMEPAGE="http://bastille-linux.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}-linux/${MY_P}.tar.bz2
	mirror://gentoo/${P}-gentoo-${PATCHVER}.patch.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="X"

RDEPEND="
	app-admin/logrotate
	dev-perl/Curses
	net-firewall/iptables
	net-firewall/psad
	virtual/logger
	X? ( dev-perl/Tk )
"

src_prepare() {
	epatch "${WORKDIR}"/${P}-gentoo-${PATCHVER}.patch

	# make sure the Perl modules go into vendor dir
	epatch "${FILESDIR}/${P}-perl.patch"
	perl_set_version

	cd "${S}" || die
	chmod a+x Install.sh bastille-ipchains bastille-netfilter
}

src_install() {
	perl_set_version
	export VENDOR_LIB

	cd "${S}" || die
	DESTDIR="${D}" ./Install.sh

	# Example configs
	cd "${S}" || die
	insinto /usr/share/Bastille
	doins *.config

	newinitd ${PN}-firewall.gentoo-init ${PN}-firewall

	# Documentation
	cd "${S}" || die
	dodoc *.txt BUGS Change* README*
	cd "${S}"/docs || die
	doman *.1m
}

pkg_postinst() {
	elog "Please be aware that when using the Server Lax, Server Moderate, or"
	elog "Server Paranoia configurations, you may need to use InteractiveBastille"
	elog "to set any advanced network information, such as masquerading and"
	elog "internal interfaces, if you plan to use them."
}
