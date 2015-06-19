# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/criu/criu-1.6.ebuild,v 1.1 2015/06/15 10:29:53 dlan Exp $

EAPI=5

inherit eutils toolchain-funcs linux-info flag-o-matic

DESCRIPTION="utility to checkpoint/restore a process tree"
HOMEPAGE="http://criu.org/"
SRC_URI="http://download.openvz.org/criu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="setproctitle"

RDEPEND="dev-libs/protobuf-c
	setproctitle? ( dev-libs/libbsd )"
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto"

CONFIG_CHECK="~CHECKPOINT_RESTORE ~NAMESPACES ~PID_NS ~FHANDLE ~EVENTFD ~EPOLL ~INOTIFY_USER
	~IA32_EMULATION ~UNIX_DIAG ~INET_DIAG ~INET_UDP_DIAG ~PACKET_DIAG ~NETLINK_DIAG"

RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.3.1-flags.patch
	epatch "${FILESDIR}"/${PN}-1.3.1-makefile.patch
	epatch "${FILESDIR}"/${PN}-1.5-automagic-libbsd.patch
}

src_compile() {
	unset ARCH
	emake CC="$(tc-getCC)" LD="$(tc-getLD)" V=1 SETPROCTITLE=$(usex setproctitle) WERROR=0 all docs
}

src_test() {
	# root privileges are required to dump all necessary info
	if [[ ${EUID} -eq 0 ]] ; then
		emake -j1 CC="$(tc-getCC)" V=1 WERROR=0 test
	fi
}

src_install() {
	emake SYSCONFDIR="${EPREFIX}"/etc PREFIX="${EPREFIX}"/usr DESTDIR="${D}" install
	dodoc CREDITS README.md
}
