# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic systemd user

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="High-performance, distributed memory object caching system"
HOMEPAGE="https://code.google.com/p/memcached/"
SRC_URI="http://www.memcached.org/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test slabs-reassign debug sasl" # hugetlbfs later

RDEPEND=">=dev-libs/libevent-1.4
		 dev-lang/perl
		 sasl? ( dev-libs/cyrus-sasl )"
DEPEND="${RDEPEND}
		test? ( virtual/perl-Test-Harness >=dev-perl/Cache-Memcached-1.24 )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.2.2-fbsd.patch"
	# Handled different upstream
	#epatch "${FILESDIR}/${PN}-1.3.3-gcc4-slab-fixup.patch"
	epatch "${FILESDIR}/${PN}-1.4.0-fix-as-needed-linking.patch"
	epatch "${FILESDIR}/${PN}-1.4.4-as-needed.patch"
	epatch "${FILESDIR}/${PN}-1.4.17-EWOULDBLOCK.patch"
	sed -i -e 's,-Werror,,g' configure.ac || die
	sed -i -e 's,AM_CONFIG_HEADER,AC_CONFIG_HEADERS,' configure.ac || die
	eautoreconf
	use slabs-reassign && append-flags -DALLOW_SLABS_REASSIGN
}

src_configure() {
	econf \
		--disable-docs \
		$(use_enable sasl)
	# The xml2rfc tool to build the additional docs requires TCL :-(
	# `use_enable doc docs`
}

src_compile() {
	# There is a heavy degree of per-object compile flags
	# Users do NOT know better than upstream. Trying to compile the testapp and
	# the -debug version with -DNDEBUG _WILL_ fail.
	append-flags -UNDEBUG -pthread
	emake testapp memcached-debug CFLAGS="${CFLAGS}"
	filter-flags -UNDEBUG
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	dobin scripts/memcached-tool
	use debug && dobin memcached-debug

	dodoc AUTHORS ChangeLog NEWS README.md doc/{CONTRIBUTORS,*.txt}

	newconfd "${FILESDIR}/memcached.confd" memcached
	newinitd "${FILESDIR}/memcached.init" memcached
	systemd_dounit "${FILESDIR}/memcached.service"
}

pkg_postinst() {
	enewuser memcached -1 -1 /dev/null daemon

	elog "With this version of Memcached Gentoo now supports multiple instances."
	elog "To enable this you should create a symlink in /etc/init.d/ for each instance"
	elog "to /etc/init.d/memcached and create the matching conf files in /etc/conf.d/"
	elog "Please see Gentoo bug #122246 for more info"
}

src_test() {
	emake -j1 test
}
