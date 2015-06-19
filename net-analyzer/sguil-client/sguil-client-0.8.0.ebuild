# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sguil-client/sguil-client-0.8.0.ebuild,v 1.3 2015/03/25 16:07:17 jlec Exp $

EAPI=5

inherit multilib

MY_PV="${PV/_p/p}"
DESCRIPTION="GUI Console for sguil Network Security Monitoring"
HOMEPAGE="http://sguil.sf.net"
SRC_URI="mirror://sourceforge/sguil/sguil-client-${MY_PV}.tar.gz"

LICENSE="QPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

RDEPEND="
	>=dev-lang/tcl-8.3:0=[-threads]
	>=dev-lang/tk-8.3:0=
	>=dev-tcltk/itcl-3.2
	>=dev-tcltk/tclx-8.3
	dev-tcltk/itk
	dev-tcltk/iwidgets
	dev-tcltk/tcllib
	net-analyzer/wireshark
	ssl? ( >=dev-tcltk/tls-1.4.1 )
"

S=${WORKDIR}/sguil-${MY_PV}

src_prepare() {
	sed -i \
		-e "/^set SGUILLIB /s:./lib:/usr/$(get_libdir)/sguil:" \
		-e '/^set ETHEREAL_PATH /s:/usr/sbin/ethereal:/usr/bin/wireshark:' \
		-e '/^set SERVERHOST /s:demo.sguil.net:localhost:' \
		-e '/^set MAILSERVER /s:mail.example.com:localhost:' \
		-e '/^set GPG_PATH /s:/usr/local/bin/gpg:/usr/bin/gpg:' \
		client/sguil.conf || die
}

src_install() {
	dobin client/sguil.tk
	insinto /etc/sguil
	doins client/sguil.conf
	insinto "/usr/$(get_libdir)/sguil"
	doins -r "${S}"/client/lib/*
	dodoc doc/*
}
