# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://neil.brown.name/portmap"
inherit toolchain-funcs user git-r3

DESCRIPTION="Netkit - portmapper"
HOMEPAGE="ftp://ftp.porcupine.org/pub/security/index.html"
SRC_URI=""

LICENSE="BSD GPL-2" # GPL-2 only for init script
SLOT="0"
KEYWORDS=""
IUSE="selinux tcpd"

DEPEND="
	tcpd? ( >=sys-apps/tcp-wrappers-7.6-r7 )
"

RDEPEND="
	selinux? ( sec-policy/selinux-portmap )
"

pkg_setup() {
	enewgroup rpc 111
	enewuser rpc 111 -1 /dev/null rpc
}

src_compile() {
	tc-export CC
	emake NO_TCP_WRAPPER="$(use tcpd || echo NO)"
}

src_install() {
	into /
	dosbin portmap
	into /usr
	dosbin pmap_dump pmap_set

	doman *.8
	dodoc BLURBv5 CHANGES README*

	newinitd "${FILESDIR}"/portmap.rc6 portmap
	newconfd "${FILESDIR}"/portmap.confd portmap
}
