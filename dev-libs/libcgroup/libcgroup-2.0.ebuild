# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic linux-info pam systemd

DESCRIPTION="Tools and libraries to configure and manage kernel control groups"
HOMEPAGE="https://github.com/libcgroup/libcgroup"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+daemon pam static-libs test +tools"
REQUIRED_USE="daemon? ( tools )"

# Use mount cgroup to build directory
# sandbox restricted to trivial build,
RESTRICT="test"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	elibc_musl? ( sys-libs/fts-standalone )
"
DEPEND="pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}"

pkg_setup() {
	local CONFIG_CHECK="~CGROUPS"
	if use daemon; then
		CONFIG_CHECK="${CONFIG_CHECK} ~CONNECTOR ~PROC_EVENTS"
	fi
	linux-info_pkg_setup
}

src_prepare() {
	default

	# Change rules file location
	find src -name *.c -o -name *.h \
		| xargs sed -i '/^#define/s:/etc/cg:/etc/cgroup/cg:'
	sed -i 's:/etc/cg:/etc/cgroup/cg:' \
		doc/man/cg* samples/*.conf README* || die "sed failed"

	# Drop native libcgconfig init config
	sed -i '/^man_MANS/s:cgred.conf.5::' \
		doc/man/Makefile.am || die "sed failed"

	# If we're not running tests, don't bother building them.
	if ! use test; then
		sed -i '/^SUBDIRS/s:tests::' Makefile.am || die
	fi

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
		$(use_enable pam) \
		$(use_enable tools) \
		${my_conf}
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	insinto /etc/cgroup
	doins samples/cgconfig.conf
	doins samples/cgrules.conf
	doins samples/cgsnapshot_blacklist.conf

	keepdir /etc/cgroup/cgconfig.d
	keepdir /etc/cgroup/cgrules.d

	if use tools; then
		newconfd "${FILESDIR}"/cgconfig.confd-r1 cgconfig
		newinitd "${FILESDIR}"/cgconfig.initd-r1 cgconfig
		systemd_dounit "${FILESDIR}"/cgconfig.service
		systemd_dounit "${FILESDIR}"/cgrules.service
	fi

	if use daemon; then
		newconfd "${FILESDIR}"/cgred.confd-r2 cgred
		newinitd "${FILESDIR}"/cgred.initd-r1 cgred
	fi
}
