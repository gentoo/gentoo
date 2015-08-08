# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs multilib

# TODO: FHS https://github.com/luvit/luvit/issues/379

DESCRIPTION="Takes node.js' architecture and dependencies and fits it in the Lua language"
HOMEPAGE="http://luvit.io/"
SRC_URI="http://luvit.io/dist/latest/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="bundled-libs examples"
# luvit Apache-2.0
# luajit MIT
# yajl BSD
LICENSE="Apache-2.0 bundled-libs? ( BSD MIT )"

# fails in portage environment
# succeeds if run manually
RESTRICT="test"

RDEPEND="
	dev-libs/openssl:0
	sys-libs/zlib
	!bundled-libs? (
		dev-lang/luajit:2[lua52compat]
		>=dev-libs/yajl-2.0.2
		net-libs/http-parser
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	rm -r deps/{openssl,zlib} || die
	epatch "${FILESDIR}"/${PN}-0.7.0-unbundle-http-parser.patch
	if use bundled-libs ; then
		sed -i \
			-e "s/-Werror//" \
			-e "s/-O3//" \
			deps/http-parser/Makefile || die "fixing flags failed!"
	else
		rm -r deps/{luajit,yajl,http-parser} || die
		# TODO: no version detection for http-parser yet
		MY_YAJL_VERSION=$($(tc-getPKG_CONFIG) --modversion yajl)
		MY_LUAJIT_VERSION=$($(tc-getPKG_CONFIG) --modversion luajit)
		sed -i \
			-e "s:^YAJL_VERSION=.*:YAJL_VERSION=${MY_YAJL_VERSION}:" \
			-e "s:^LUAJIT_VERSION=.*:LUAJIT_VERSION=${MY_LUAJIT_VERSION}:" \
			Makefile || die "setting yajl version failed"
	fi

}

src_configure() {
	# skip retarded gyp build system
	:
}

src_compile() {
	tc-export CC AR

	emake -C deps/cares

	myemakeargs=(
		DEBUG=0
		WERROR=0
		USE_SYSTEM_SSL=1
		# bundled luajit is compiled with special flags
		USE_SYSTEM_LUAJIT=$(usex bundled-libs "0" "1")
		USE_SYSTEM_YAJL=$(usex bundled-libs "0" "1")
		USE_SYSTEM_HTTPPARSER=$(usex bundled-libs "0" "1")
		USE_SYSTEM_ZLIB=1
		PREFIX=/usr
		LIBDIR="${D%/}"/usr/$(get_libdir)/${PN}
		DESTDIR="${D}"
	)

	emake "${myemakeargs[@]}" all
}

src_install() {
	emake "${myemakeargs[@]}" install
	dodoc TODO ChangeLog README.markdown errors.markdown

	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
