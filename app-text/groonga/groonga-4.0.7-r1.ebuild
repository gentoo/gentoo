# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils libtool user

DESCRIPTION="An Embeddable Fulltext Search Engine"
HOMEPAGE="http://groonga.org/"
SRC_URI="http://packages.groonga.org/source/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="abort benchmark debug doc dynamic-malloc-change +exact-alloc-count examples fmalloc futex libedit libevent lzo mecab msgpack +nfkc ruby sphinx static-libs uyield zeromq zlib"

RDEPEND="benchmark? ( >=dev-libs/glib-2.8 )
	libedit? ( >=dev-libs/libedit-3 )
	libevent? ( dev-libs/libevent )
	lzo? ( dev-libs/lzo )
	mecab? ( >=app-text/mecab-0.80 )
	msgpack? ( dev-libs/msgpack )
	ruby? ( dev-lang/ruby )
	sphinx? ( >=dev-python/sphinx-1.0.1 )
	zeromq? ( net-libs/zeromq )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sphinx? ( dev-python/sphinx )"

REQUIRED_USE=" abort? ( dynamic-malloc-change ) fmalloc? ( dynamic-malloc-change ) sphinx? ( doc )"

pkg_setup() {
	enewgroup groonga
	enewuser groonga -1 -1 -1 groonga
}

src_prepare() {
	elibtoolize
}

src_configure() {
	# httpd is a bundled copy of nginx; disabled for security reasons
	# prce only is used with httpd
	# kytea and libstemmer are not available in portage
	econf \
		--disable-groonga-httpd \
		--without-pcre \
		--without-kytea \
		--without-libstemmer \
		--with-log-path="${EROOT}var/log/${PN}.log" \
		--docdir="${EROOT}usr/share/doc/${P}" \
		$(use_enable abort) \
		$(use_enable benchmark) \
		$(use_enable debug memory-debug) \
		$(use_enable doc document) \
		$(use_enable dynamic-malloc-change) \
		$(use_enable exact-alloc-count) \
		$(use_enable fmalloc) \
		$(use_enable futex) \
		$(use_enable libedit) \
		$(use_with libevent) \
		$(use_with lzo) \
		$(use_with mecab) \
		$(use_with msgpack message-pack "${EROOT}usr") \
		$(use_enable nfkc) \
		$(use_with ruby) \
		$(use_with sphinx sphinx-build) \
		$(use_enable static-libs static) \
		$(use_enable uyield) \
		$(use_enable zeromq) \
		$(use_with zlib)
}

src_install() {
	default

	prune_libtool_files

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	keepdir /var/{log,lib}/${PN}
	fowners groonga:groonga /var/{log,lib}/${PN}

	dodoc README.md

	use examples || rm -r "${D}usr/share/${PN}" || die
	# Extra init script
	rm -r "${D}usr/sbin/groonga-httpd-restart" || die
}
