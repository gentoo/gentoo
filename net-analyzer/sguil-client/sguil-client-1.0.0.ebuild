# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_p/p}"
DESCRIPTION="GUI Console for sguil Network Security Monitoring"
HOMEPAGE="https://github.com/bammv/sguil"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P/-client}.tar.gz"

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
	default
	sed -i \
		-e "/^set SGUILLIB /s:./lib:/usr/$(get_libdir)/sguil:" \
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
