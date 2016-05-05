# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils toolchain-funcs linux-info flag-o-matic python-r1 python-utils-r1

DESCRIPTION="utility to checkpoint/restore a process tree"
HOMEPAGE="http://criu.org/"
SRC_URI="http://download.openvz.org/criu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="python setproctitle"

RDEPEND="dev-libs/protobuf-c
	dev-libs/libnl:3
	python? ( ${PYTHON_DEPS} )
	setproctitle? ( dev-libs/libbsd )"
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto"
RDEPEND="${RDEPEND}
	python? (
		dev-libs/protobuf[python,${PYTHON_USEDEP}]
		dev-python/ipaddr[${PYTHON_USEDEP}]
	)"

CONFIG_CHECK="~CHECKPOINT_RESTORE ~NAMESPACES ~PID_NS ~FHANDLE ~EVENTFD ~EPOLL ~INOTIFY_USER
	~IA32_EMULATION ~UNIX_DIAG ~INET_DIAG ~INET_UDP_DIAG ~PACKET_DIAG ~NETLINK_DIAG"

RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/2.0/${PN}-2.0-flags.patch
	epatch "${FILESDIR}"/${PV}/${P}-makefile.patch
	epatch "${FILESDIR}"/2.0/${PN}-2.0-automagic-libbsd.patch
	epatch "${FILESDIR}"/2.0/${PN}-2.0-sysroot.patch
}

criu_arch() {
	# criu infers the arch from $(uname -m).  We never want this to happen.
	case ${ARCH} in
	amd64) echo "x86";;
	arm64) echo "aarch64";;
	*)     echo "${ARCH}";;
	esac
}

src_compile() {
	RAW_LDFLAGS="$(raw-ldflags)" emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		OBJCOPY="$(tc-getOBJCOPY)" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		ARCH="$(criu_arch)" \
		V=1 WERROR=0 DEBUG=0 \
		SETPROCTITLE=$(usex setproctitle) \
		PYCRIU=$(usex python) \
		all docs
}

src_test() {
	# root privileges are required to dump all necessary info
	if [[ ${EUID} -eq 0 ]] ; then
		emake -j1 CC="$(tc-getCC)" ARCH="$(criu_arch)" V=1 WERROR=0 test
	fi
}

install_crit() {
	"${PYTHON:-python}" ../scripts/crit-setup.py install --root="${D}" --prefix="${EPREFIX}/usr/"
}

src_install() {
	emake \
		ARCH="$(criu_arch)" \
		PREFIX="${EPREFIX}"/usr \
		LOGROTATEDIR="${EPREFIX}"/etc/logrotate.d \
		DESTDIR="${D}" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		install

	dodoc CREDITS README.md

	if use python ; then
		cd lib
		python_foreach_impl install_crit
	fi
}
