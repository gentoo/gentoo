# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/memcached/memcached-1.3.3-r5.ebuild,v 1.2 2014/01/08 06:19:22 vapier Exp $

inherit eutils autotools flag-o-matic user

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="High-performance, distributed memory object caching system"
HOMEPAGE="http://code.google.com/p/memcached/"
SRC_URI="http://memcached.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="test slabs-reassign"

RDEPEND=">=dev-libs/libevent-1.4
		 dev-lang/perl"
DEPEND="${RDEPEND}
		test? ( virtual/perl-Test-Harness >=dev-perl/Cache-Memcached-1.24 )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-1.2.2-fbsd.patch"
	epatch "${FILESDIR}/${PN}-1.3.3-gcc4-slab-fixup.patch"
	sed -i -e 's,-Werror,,g' configure.ac || die "sed failed"
	eautoreconf
	use slabs-reassign && append-flags -DALLOW_SLABS_REASSIGN
}

src_compile() {
	econf
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dobin scripts/memcached-tool

	dodoc AUTHORS ChangeLog NEWS README TODO doc/{CONTRIBUTORS,*.txt}

	newconfd "${FILESDIR}"/1.3.3/conf memcached
	newinitd "${FILESDIR}"/1.3.3/init memcached
}

pkg_postinst() {
	enewuser memcached -1 -1 /dev/null daemon

	elog "With this version of Memcached Gentoo now supports multiple instances."
	elog "To enable this you should create a symlink in /etc/init.d/ for each instance"
	elog "to /etc/init.d/memcached and create the matching conf files in /etc/conf.d/"
	elog "Please see Gentoo bug #122246 for more info"
}

src_test() {
	emake -j1 test || die "Failed testing"
}
