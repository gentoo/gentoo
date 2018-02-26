# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic multilib-minimal python-single-r1 systemd user

MY_P=${PN}-${PV/_/}
DESCRIPTION="A validating, recursive and caching DNS resolver"
HOMEPAGE="http://unbound.net/"
SRC_URI="http://unbound.net/downloads/${MY_P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~x86"
IUSE="debug dnscrypt dnstap +ecdsa gost libressl python selinux static-libs systemd test threads"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Note: expat is needed by executable only but the Makefile is custom
# and doesn't make it possible to easily install the library without
# the executables. MULTILIB_USEDEP may be dropped once build system
# is fixed.

CDEPEND=">=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}]
	>=dev-libs/libevent-2.0.21:0=[${MULTILIB_USEDEP}]
	libressl? ( >=dev-libs/libressl-2.2.4:0[${MULTILIB_USEDEP}] )
	!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0[${MULTILIB_USEDEP}] )
	dnscrypt? ( dev-libs/libsodium )
	dnstap? (
		dev-libs/fstrm[${MULTILIB_USEDEP}]
		>=dev-libs/protobuf-c-1.0.2-r1[${MULTILIB_USEDEP}]
	)
	ecdsa? (
		!libressl? ( dev-libs/openssl:0[-bindist] )
	)
	python? ( ${PYTHON_DEPS} )"

DEPEND="${CDEPEND}
	python? ( dev-lang/swig )
	test? (
		net-dns/ldns-utils[examples]
		dev-util/splint
		app-text/wdiff
	)
	systemd? ( sys-apps/systemd )
	virtual/pkgconfig"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-bind )"

# bug #347415
RDEPEND="${RDEPEND}
	net-dns/dnssec-root"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup unbound
	enewuser unbound -1 -1 /etc/unbound unbound
	# improve security on existing installs (bug #641042)
	# as well as new installs where unbound homedir has just been created
	if [[ -d "${ROOT}/etc/unbound" ]]; then
		chown --no-dereference --from=unbound root "${ROOT}/etc/unbound"
	fi

	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# To avoid below error messages, set 'trust-anchor-file' to same value in
	# 'auto-trust-anchor-file'.
	# [23109:0] error: Could not open autotrust file for writing,
	# /etc/dnssec/root-anchors.txt: Permission denied
	epatch "${FILESDIR}"/${PN}-1.5.7-trust-anchor-file.patch

	# required for the python part
	multilib_copy_sources
}

src_configure() {
	[[ ${CHOST} == *-darwin* ]] || append-ldflags -Wl,-z,noexecstack
	multilib-minimal_src_configure
}

multilib_src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable gost) \
		$(use_enable dnscrypt) \
		$(use_enable dnstap) \
		$(use_enable ecdsa) \
		$(use_enable static-libs static) \
		$(use_enable systemd) \
		$(multilib_native_use_with python pythonmodule) \
		$(multilib_native_use_with python pyunbound) \
		$(use_with threads pthreads) \
		--disable-flto \
		--disable-rpath \
		--with-libevent="${EPREFIX}"/usr \
		--with-pidfile="${EPREFIX}"/var/run/unbound.pid \
		--with-rootkey-file="${EPREFIX}"/etc/dnssec/root-anchors.txt \
		--with-ssl="${EPREFIX}"/usr \
		--with-libexpat="${EPREFIX}"/usr

		# http://unbound.nlnetlabs.nl/pipermail/unbound-users/2011-April/001801.html
		# $(use_enable debug lock-checks) \
		# $(use_enable debug alloc-checks) \
		# $(use_enable debug alloc-lite) \
		# $(use_enable debug alloc-nonregional) \
}

multilib_src_install_all() {
	prune_libtool_files --modules
	use python && python_optimize

	newinitd "${FILESDIR}"/unbound.initd unbound
	newconfd "${FILESDIR}"/unbound.confd unbound

	systemd_dounit "${FILESDIR}"/unbound.service
	systemd_dounit "${FILESDIR}"/unbound.socket
	systemd_newunit "${FILESDIR}"/unbound_at.service "unbound@.service"
	systemd_dounit "${FILESDIR}"/unbound-anchor.service

	dodoc doc/{README,CREDITS,TODO,Changelog,FEATURES}

	# bug #315519
	dodoc contrib/unbound_munin_

	docinto selinux
	dodoc contrib/selinux/*

	exeinto /usr/share/${PN}
	doexe contrib/update-anchor.sh

	# create space for auto-trust-anchor-file...
	keepdir /etc/unbound/var
	# ... and point example config to it
	sed -i '/# auto-trust-anchor-file:/s,/etc/dnssec/root-anchors.txt,/etc/unbound/var/root-anchors.txt,' "${ED}/etc/unbound/unbound.conf"
}

pkg_postinst() {
	# make var/ writable by unbound
	if [[ -d "${ROOT}/etc/unbound/var" ]]; then
		chown --no-dereference --from=root unbound: "${ROOT}/etc/unbound/var"
	fi
	einfo ""
	einfo "If you want unbound to automatically update the root-anchor file for DNSSEC validation"
	einfo "set 'auto-trust-anchor-file: /etc/unbound/var/root-anchors.txt' in /etc/unbound/unbound.conf"
	einfo "and run"
	einfo ""
	einfo "  su -s /bin/sh -c '/usr/sbin/unbound-anchor -a /etc/unbound/var/root-anchors.txt' unbound"
	einfo ""
	einfo "as root to create it initially before starting unbound for the first time after enabling this."
	einfo ""
}
