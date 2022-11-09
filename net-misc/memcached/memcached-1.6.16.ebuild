# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic systemd

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="High-performance, distributed memory object caching system"
HOMEPAGE="http://memcached.org/"
SRC_URI="https://www.memcached.org/files/${MY_P}.tar.gz
	https://www.memcached.org/files/old/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug sasl seccomp selinux slabs-reassign ssl test" # hugetlbfs later

RDEPEND=">=dev-libs/libevent-1.4:=
	dev-lang/perl
	sasl? ( dev-libs/cyrus-sasl )
	seccomp? ( sys-libs/libseccomp )
	selinux? ( sec-policy/selinux-memcached )
	ssl? ( >=dev-libs/openssl-1.1.0g:= )"
DEPEND="${RDEPEND}
	acct-user/memcached
	test? ( virtual/perl-Test-Harness >=dev-perl/Cache-Memcached-1.24 ssl? ( dev-perl/IO-Socket-SSL ) )"

S="${WORKDIR}/${MY_P}"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-1.2.2-fbsd.patch"
	"${FILESDIR}/${PN}-1.4.0-fix-as-needed-linking.patch"
	"${FILESDIR}/${PN}-1.4.4-as-needed.patch"
	"${FILESDIR}/${PN}-1.4.17-EWOULDBLOCK.patch"
)

src_prepare() {
	default

	sed -i -e 's,-Werror,,g' configure.ac || die
	sed -i -e 's,AM_CONFIG_HEADER,AC_CONFIG_HEADERS,' configure.ac || die

	eautoreconf

	use slabs-reassign && append-flags -DALLOW_SLABS_REASSIGN

	# Tweak upstream systemd unit to use Gentoo variables/envfile.
	# As noted by bug #587440
	sed -i -e '/^ExecStart/{
			s,{USER},{MEMCACHED_RUNAS},g;
			s,{CACHESIZE},{MEMUSAGE},g;
			s,OPTIONS,MISC_OPTS,g;
		};
		/Environment=/{s,OPTIONS,MISC_OPTS,g;};
		/EnvironmentFile=/{s,/sysconfig/,/conf.d/,g;};
		' \
		"${S}"/scripts/memcached.service
}

src_configure() {
	econf \
		--disable-docs \
		$(use_enable sasl) \
		$(use_enable ssl tls)
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

src_test() {
	emake -j1 test
}

src_install() {
	emake DESTDIR="${D}" install
	dobin scripts/memcached-tool
	use debug && dobin memcached-debug

	dodoc AUTHORS ChangeLog NEWS README.md doc/{CONTRIBUTORS,*.txt}

	newconfd "${FILESDIR}/memcached.confd" memcached
	newinitd "${FILESDIR}/memcached.init2" memcached
	systemd_dounit "${S}/scripts/memcached.service"
}

pkg_postinst() {
	elog "With this version of Memcached Gentoo now supports multiple instances."
	elog "To enable this you should create a symlink in /etc/init.d/ for each instance"
	elog "to /etc/init.d/memcached and create the matching conf files in /etc/conf.d/"
	elog "Please see Gentoo bug #122246 for more info"
}
