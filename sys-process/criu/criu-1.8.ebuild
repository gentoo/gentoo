# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	epatch "${FILESDIR}"/${PN}-1.8-makefile.patch
	epatch "${FILESDIR}"/${PN}-1.7-automagic-libbsd.patch
}

criu_arch() {
	# criu infers the arch from $(uname -m).  We never want this to happen.
	case ${ARCH} in
	amd64) echo "x86_64";;
	arm64) echo "aarch64";;
	x86)   echo "i386";;
	*)     echo "${ARCH}";;
	esac
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		OBJCOPY="$(tc-getOBJCOPY)" \
		ARCH="$(criu_arch)" \
		V=1 WERROR=0 \
		SETPROCTITLE=$(usex setproctitle) \
		all docs
}

src_test() {
	# root privileges are required to dump all necessary info
	if [[ ${EUID} -eq 0 ]] ; then
		emake -j1 CC="$(tc-getCC)" ARCH="$(criu_arch)" V=1 WERROR=0 test
	fi
}

src_install() {
	emake \
		ARCH="$(criu_arch)" \
		PREFIX="${EPREFIX}"/usr \
		LOGROTATEDIR="${EPREFIX}"/etc/logrotate.d \
		DESTDIR="${D}" \
		install

	dodoc CREDITS README.md
}
