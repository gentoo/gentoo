# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils perl-functions

PATCHVER=0.2
MY_PN=${PN/b/B}
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_PN}
DESCRIPTION="Bastille-Linux is a security hardening tool"
HOMEPAGE="http://bastille-linux.org/"
SRC_URI="mirror://sourceforge/${PN}-linux/${MY_P}.tar.bz2
	mirror://gentoo/${P}-gentoo-${PATCHVER}.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64"
IUSE="X"

RDEPEND="
	net-firewall/iptables
	app-admin/logrotate
	dev-lang/perl:=
	dev-perl/Curses
	net-firewall/psad
	X? ( dev-perl/Tk )
	virtual/logger
"

PATCHES=(
	"${WORKDIR}"/${P}-gentoo-${PATCHVER}.patch

	# make sure the Perl modules go into vendor dir
	"${FILESDIR}/${P}-perl.patch"

	# prevent file collision, bug 536292
	"${FILESDIR}/${P}-renamewidgets.patch"

	# openrc runscript rename
	"${FILESDIR}/${P}-openrc.patch"
)

src_prepare() {
	perl_set_version

	default

	cd "${S}" || die
	chmod a+x Install.sh bastille-ipchains bastille-netfilter || die
}

src_install() {
	perl_set_version
	export VENDOR_LIB

	cd "${S}" || die
	DESTDIR="${D}" ./Install.sh || die

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
