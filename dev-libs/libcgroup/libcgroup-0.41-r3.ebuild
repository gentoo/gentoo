# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils flag-o-matic linux-info pam

DESCRIPTION="Tools and libraries to configure and manage kernel control groups"
HOMEPAGE="http://libcg.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/libcg/${PN}/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+daemon elibc_musl debug pam static-libs +tools"

RDEPEND="pam? ( virtual/pam )"

DEPEND="
	${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	elibc_musl? ( sys-libs/fts-standalone )
	"
REQUIRED_USE="daemon? ( tools )"

DOCS=(README_daemon README README_systemd INSTALL)
pkg_setup() {
	local CONFIG_CHECK="~CGROUPS"
	if use daemon; then
		CONFIG_CHECK="${CONFIG_CHECK} ~CONNECTOR ~PROC_EVENTS"
	fi
	linux-info_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-replace_DECLS.patch
	epatch "${FILESDIR}"/${P}-replace_INLCUDES.patch
	epatch "${FILESDIR}"/${P}-reorder-headers.patch

	# Change rules file location
	sed -e 's:/etc/cgrules.conf:/etc/cgroup/cgrules.conf:' \
		-i src/libcgroup-internal.h || die "sed failed"
	sed -e 's:\(pam_cgroup_la_LDFLAGS.*\):\1\ -avoid-version:' \
		-i src/pam/Makefile.am || die "sed failed"
	sed -e 's#/var/run#/run#g' -i configure.in || die "sed failed"

	eautoreconf
}

src_configure() {
	local my_conf

	if use pam; then
		my_conf=" --enable-pam-module-dir=$(getpam_mod_dir) "
	fi

	use elibc_musl && append-ldflags "-lfts"
	econf \
		$(use_enable static-libs static) \
		$(use_enable daemon) \
		$(use_enable debug) \
		$(use_enable pam) \
		$(use_enable tools) \
		${my_conf}
}

src_test() {
	# Use mount cgroup to build directory
	# sandbox restricted to trivial build,
	# possible kill Diego tanderbox ;)
	true
}

src_install() {
	default
	prune_libtool_files --all

	insinto /etc/cgroup
	doins samples/*.conf || die

	if use tools; then
		newconfd "${FILESDIR}"/cgconfig.confd-r1 cgconfig || die
		newinitd "${FILESDIR}"/cgconfig.initd-r1 cgconfig || die
	fi

	if use daemon; then
		newconfd "${FILESDIR}"/cgred.confd-r1 cgred || die
		newinitd "${FILESDIR}"/cgred.initd-r1 cgred || die
	fi
}
