# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit libtool user

DESCRIPTION="An Embeddable Fulltext Search Engine"
HOMEPAGE="https://groonga.org/"
SRC_URI="https://packages.groonga.org/source/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="abort benchmark debug doc dynamic-malloc-change +exact-alloc-count examples fmalloc futex jemalloc libedit libevent lzo +mecab msgpack +nfkc sphinx static-libs uyield zeromq zlib zstd"

RDEPEND=">=dev-libs/onigmo-6.1.1:0=
	benchmark? ( >=dev-libs/glib-2.8 )
	jemalloc? ( dev-libs/jemalloc:0= )
	libedit? ( >=dev-libs/libedit-3 )
	libevent? ( dev-libs/libevent:0= )
	lzo? ( dev-libs/lzo )
	mecab? ( >=app-text/mecab-0.80 )
	msgpack? ( dev-libs/msgpack )
	sphinx? ( >=dev-python/sphinx-1.0.1 )
	zeromq? ( net-libs/zeromq:0= )
	zlib? ( sys-libs/zlib:0= )
	zstd? ( app-arch/zstd:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sphinx? ( dev-python/sphinx )"

REQUIRED_USE=" abort? ( dynamic-malloc-change ) fmalloc? ( dynamic-malloc-change ) sphinx? ( doc )"

pkg_setup() {
	enewgroup groonga
	enewuser groonga -1 -1 -1 groonga
}

src_prepare() {
	default_src_prepare
	elibtoolize
}

src_configure() {
	# httpd is a bundled copy of nginx; disabled for security reasons
	# prce only is used with httpd
	# Apache arrow, kytea and libstemmer are not available in Gentoo repo
	# ruby is only used for an http test
	local econfopts=(
		--disable-groonga-httpd
		--without-pcre
		--without-kytea
		--without-libstemmer
		--disable-arrow
		--with-log-path="${EPREFIX}"/var/log/${PN}.log
		--without-ruby
		--with-shared-onigmo
		--with-onigmo=system
		$(use_enable abort)
		$(use_enable benchmark)
		$(use_enable debug memory-debug)
		$(use_enable doc document)
		$(use_enable dynamic-malloc-change)
		$(use_enable exact-alloc-count)
		$(use_enable fmalloc)
		$(use_enable futex)
		$(use_with jemalloc)
		$(use_enable libedit)
		$(use_with libevent)
		$(use_with lzo)
		$(use_with mecab)
		$(use_enable msgpack message-pack)
		$(use_with msgpack message-pack "${EROOT%/}/usr")
		$(use_enable nfkc)
		$(use_with sphinx sphinx-build)
		$(use_enable static-libs static)
		$(use_enable uyield)
		$(use_enable zeromq)
		$(use_with zlib)
		$(use_with zstd)
	)
	econf "${econfopts[@]}"
}

src_install() {
	local DOCS=( README.md )
	default

	find "${D}" -name '*.la' -delete || die

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	keepdir /var/{log,lib}/${PN}
	fowners groonga:groonga /var/{log,lib}/${PN}

	use examples || rm -r "${D%/}/usr/share/${PN}" || die
}
