# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/rpcbind/rpcbind-0.2.0-r1.ebuild,v 1.13 2014/11/02 09:27:00 swift Exp $

EAPI="2"

inherit autotools eutils systemd

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.infradead.org/~steved/rpcbind.git"
	inherit autotools eutils git-2
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
fi

DESCRIPTION="portmap replacement which supports RPC over various protocols"
HOMEPAGE="http://sourceforge.net/projects/rpcbind/"

LICENSE="BSD"
SLOT="0"
IUSE="selinux tcpd"

CDEPEND="net-libs/libtirpc
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-rpcbind )
"
src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	else
		sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die #467018
		epatch "${FILESDIR}"/${P}-pkgconfig.patch
		epatch "${FILESDIR}"/${P}-no-nss.patch
		eautoreconf
	fi
}

src_configure() {
	econf \
		--bindir=/sbin \
		$(use_enable tcpd libwrap)
}

src_install() {
	emake DESTDIR="${D}" install || die
	doman man/rpc{bind,info}.8
	dodoc AUTHORS ChangeLog NEWS README
	newinitd "${FILESDIR}"/rpcbind.initd rpcbind || die
	newconfd "${FILESDIR}"/rpcbind.confd rpcbind || die
	systemd_dounit "${FILESDIR}"/rpcbind.service
}
