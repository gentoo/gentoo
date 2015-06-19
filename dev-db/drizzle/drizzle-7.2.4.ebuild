# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/drizzle/drizzle-7.2.4.ebuild,v 1.5 2014/03/01 22:26:02 mgorny Exp $

EAPI=5

inherit python flag-o-matic libtool autotools eutils pam user versionator

MY_P="${P}-alpha"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Database optimized for Cloud and Net applications"
HOMEPAGE="http://drizzle.org"
SRC_URI="http://launchpad.net/drizzle/$(get_version_component_range 1-2)/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug tcmalloc doc memcache curl pam gearman +md5 ldap v8"

RDEPEND="tcmalloc? ( dev-util/google-perftools )
		sys-libs/readline
		sys-apps/util-linux
		dev-libs/libpcre
		dev-libs/openssl
		>=dev-libs/libevent-1.4
		>=dev-libs/protobuf-2.1.0
		dev-libs/libaio
		>=dev-libs/boost-1.52.0-r1:=[threads]
		gearman? ( >=sys-cluster/gearmand-0.12 )
		pam? ( sys-libs/pam )
		curl? ( net-misc/curl )
		memcache? ( >=dev-libs/libmemcached-0.39 )
		md5? ( >=dev-libs/libgcrypt-1.4.2:0 )
		ldap? ( net-nds/openldap )
		v8? ( dev-lang/v8 )
		!dev-db/libdrizzle"

DEPEND="${RDEPEND}
		=dev-lang/python-2*
		sys-devel/gettext
		dev-util/intltool
		dev-util/gperf
		sys-devel/flex
		dev-python/sphinx
		doc? ( app-doc/doxygen )"

pkg_setup() {
	enewuser drizzle -1 -1 /dev/null nogroup
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-7.2.3-libtool.patch" \
		"${FILESDIR}/${PN}-7.2.3+automake-1.12.patch" \
		"${FILESDIR}/${PN}-7.2.4+boost-1.50.patch" \
		"${FILESDIR}/${P}-fix-boost_thread-detection.patch"

	python_convert_shebangs -r 2 .

	epatch_user
	eautoreconf
}

src_configure() {
	local myconf=

	if use debug; then
		append-cppflags -DDEBUG
	fi

	# while I applaud upstreams goal of 0 compiler warnings
	# the 1412 release didn't achieve it.
	append-flags -Wno-error

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
		--without-hello-world-plugin \
		--disable-rabbitmq-plugin --without-rabbitmq-plugin \
		--disable-zeromq-plugin --without-zeromq-plugin \
		--with-auth-test-plugin \
		--with-auth-file-plugin \
		--with-simple-user-policy-plugin \
		--enable-logging-stats-plugin \
		--with-logging-stats-plugin \
		--enable-console-plugin \
		$(use_enable gearman libgearman) \
		$(use_enable ldap libldap) \
		$(use_enable memcache libmemcached) \
		$(use_enable tcmalloc) \
		$(use_with curl auth-http-plugin) \
		$(use_with gearman gearman-udf-plugin) \
		$(use_with gearman logging-gearman-plugin) \
		$(use_with ldap auth-ldap-plugin) \
		$(use_with md5 md5-plugin) \
		$(use_with pam auth-pam-plugin) \
		$(use_with v8 js-plugin) \
		${myconf}
}

src_compile() {
	emake V=1 all $(use doc && echo doxygen)
}

# currently not working as of 7.2.3
RESTRICT=test

src_test() {
	if [[ ${EUID} == 0 ]]; then
		eerror "You cannot run tests as root."
		eerror "Please enable FEATURES=userpriv before proceeding."
		return 1
	fi

	default
}

DOCS=( AUTHORS NEWS README )

src_install() {
	default

	find "${D}" -name '*.la' -delete || die

	if use doc; then
		docinto apidoc
		pushd docs/html
		dohtml -r .
		popd
	fi

	newinitd "${FILESDIR}"/drizzle.init.d.2 drizzled
	newconfd "${FILESDIR}"/drizzle.conf.d drizzled

	if ! use gearman; then
		sed -i -e '/need gearmand/d' "${D}"/etc/init.d/drizzled \
			|| die "unable to sed init script (gearman)"
	fi

	if ! use memcache; then
		sed -i -e '/need memcached/d' "${D}"/etc/init.d/drizzled \
			|| die "unable to sed init script (memcache)"
	fi

	keepdir /var/log/drizzle
	keepdir /var/lib/drizzle/drizzled
	keepdir /etc/drizzle

	fperms 0755 /var/log/drizzle
	fperms -R 0700 /var/lib/drizzle

	fowners drizzle:nogroup /var/log/drizzle
	fowners -R drizzle:nogroup /var/lib/drizzle

	pamd_mimic system-auth drizzle auth account session
}
