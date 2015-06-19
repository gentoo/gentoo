# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/drizzle/drizzle-7.1.33.ebuild,v 1.4 2014/03/01 22:26:02 mgorny Exp $

EAPI=2

WANT_AUTOMAKE=1.11

inherit flag-o-matic libtool autotools eutils pam user versionator

MY_P="${P}-stable"
S="${WORKDIR}/${MY_P}"
DIR_PV="$(get_version_component_range 1-2)/${PV}"

DESCRIPTION="Database optimized for Cloud and Net applications"
HOMEPAGE="http://drizzle.org"
SRC_URI="http://launchpad.net/drizzle/${DIR_PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug tcmalloc doc memcache curl pam gearman +md5 ldap haildb"

RDEPEND="tcmalloc? ( dev-util/google-perftools )
		sys-libs/readline
		sys-apps/util-linux
		dev-libs/libpcre
		>=dev-libs/libevent-1.4
		>=dev-libs/protobuf-2.1.0
		gearman? ( >=sys-cluster/gearmand-0.12 )
		pam? ( sys-libs/pam )
		curl? ( net-misc/curl )
		memcache? ( >=dev-libs/libmemcached-0.39 )
		md5? ( >=dev-libs/libgcrypt-1.4.2:0 )
		haildb? ( >=dev-db/haildb-2.3.2 )
		>=dev-libs/boost-1.32
		ldap? ( net-nds/openldap )
		!dev-db/libdrizzle"

DEPEND="${RDEPEND}
		sys-devel/gettext
		dev-util/intltool
		dev-util/gperf
		sys-devel/flex
		doc? ( app-doc/doxygen )
		>=dev-util/boost-build-1.32"

pkg_setup() {
	enewuser drizzle -1 -1 /dev/null nogroup
}

src_prepare() {
	AT_M4DIR="m4" eautoreconf
	elibtoolize
}

src_configure() {
	local myconf=

	if use debug; then
		append-cppflags -DDEBUG
	fi

	# while I applaud upstreams goal of 0 compiler warnings
	# the 1412 release didn't achieve it.
	append-flags -Wno-error

	# Bug #362901
	append-cppflags -DBOOST_FILESYSTEM_VERSION=2

	# NOTE disable-all and without-all no longer recognized options
	# NOTE using --enable on some plugins can cause test failures.
	# --with should be used instead. A discussion about this here:
	# https://bugs.launchpad.net/drizzle/+bug/598659
	# TODO (upstream)
	# $(use_with memcache memcached-stats-plugin) \
	# $(use_with memcache memcached-functions-plugin) \

	econf \
		--disable-static \
		--disable-dependency-tracking \
		--disable-mtmalloc \
		$(use_enable tcmalloc) \
		$(use_enable memcache libmemcached) \
		$(use_enable gearman libgearman) \
		$(use_enable ldap libldap) \
		$(use_with curl auth-http-plugin) \
		$(use_with pam auth-pam-plugin) \
		$(use_with md5 md5-plugin) \
		$(use_with gearman gearman-udf-plugin) \
		$(use_with gearman logging-gearman-plugin) \
		$(use_with ldap auth-ldap-plugin) \
		--without-hello-world-plugin \
		--disable-pbxt-plugin --without-pbxt-plugin \
		--disable-rabbitmq-plugin --without-rabbitmq-plugin \
		$(use_enable haildb libhaildb) \
		$(use_enable haildb haildb-plugin) \
		$(use_with haildb haildb-plugin) \
		--with-auth-test-plugin \
		--with-auth-file-plugin \
		--with-simple-user-policy-plugin \
		--enable-logging-stats-plugin \
		--with-logging-stats-plugin \
		--enable-console-plugin \
		--enable-archive-plugin \
		${myconf}

}

src_compile() {
	emake all $(use doc && echo doxygen) || die "build failed"
}

# 5-10 min eta
src_test() {
	# If you want to turn off a test, rename to suffix of .DISABLED
	# Explicitly allow parallel make check
	emake check || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS README || die

	find "${D}" -name '*.la' -delete || die

	if use doc; then
		docinto apidoc
		pushd docs/html
		dohtml -r .
		popd
	fi

	newinitd "${FILESDIR}"/drizzle.init.d drizzled || die
	newconfd "${FILESDIR}"/drizzle.conf.d drizzled || die

	if ! use gearman; then
		sed -i -e '/need gearmand/d' "${D}"/etc/init.d/drizzled \
			|| die "unable to sed init script (gearman)"
	fi

	if ! use memcache; then
		sed -i -e '/need memcached/d' "${D}"/etc/init.d/drizzled \
			|| die "unable to sed init script (memcache)"
	fi

	keepdir /var/run/drizzle || die
	keepdir /var/log/drizzle || die
	keepdir /var/lib/drizzle/drizzled || die
	keepdir /etc/drizzle || die

	fperms 0755 /var/run/drizzle || die
	fperms 0755 /var/log/drizzle || die
	fperms -R 0700 /var/lib/drizzle || die

	fowners drizzle:nogroup /var/run/drizzle || die
	fowners drizzle:nogroup /var/log/drizzle || die
	fowners -R drizzle:nogroup /var/lib/drizzle || die

	pamd_mimic system-auth drizzle auth account session
}
