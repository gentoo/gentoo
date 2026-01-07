# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

# Upstream maintains 3 release channels: https://xmlrpc-c.sourceforge.net/release.html
# 1. Only the "Super Stable" series is released as a tarball
# 2. SVN tagging of releases seems spotty: https://svn.code.sf.net/p/xmlrpc-c/code/release_number/
# Because of this, we are following the "Super Stable" release channel

DESCRIPTION="A lightweight RPC library based on XML and HTTP"
HOMEPAGE="https://xmlrpc-c.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0/4.59"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-solaris"
IUSE="abyss +cgi +curl +cxx +libxml2 static-libs threads test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( abyss curl cxx )"

RDEPEND="
	dev-libs/openssl:=
	sys-libs/ncurses:=
	sys-libs/readline:=
	curl? ( net-misc/curl )
	libxml2? ( dev-libs/libxml2 )
"
DEPEND="${RDEPEND}"

# configure calls curl-config, hence curl in BDEPEND
BDEPEND="
	virtual/pkgconfig
	curl? ( net-misc/curl )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.51.06-pkg-config-libxml2.patch
	"${FILESDIR}"/${PN}-1.51.06-pkg-config-openssl.patch
)

pkg_setup() {
	use curl || ewarn "Curl support disabled: No client library will be built"
}

src_prepare() {
	default

	sed -i \
		-e "/CFLAGS_COMMON/s|-g -O3$||" \
		-e "/CXXFLAGS_COMMON/s|-g$||" \
		common.mk || die
	eautoconf
}

src_configure() {
	tc-export PKG_CONFIG

	econf \
		--disable-libwww-client \
		--disable-wininet-client \
		--without-libwww-ssl \
		$(use_enable abyss abyss-server) \
		$(use_enable cgi cgi-server) \
		$(use_enable curl curl-client) \
		$(use_enable cxx cplusplus) \
		$(use_enable libxml2 libxml2-backend) \
		$(use_enable threads abyss-threads)
}

src_compile() {
	default

	# Tools building is broken in this release
	#use tools && emake -rC "${S}"/tools
}

src_install() {
	default

	use static-libs || find "${D}" -type f -name \*.a -delete

	# Tools building is broken in this release
	#use tools && emake DESTDIR="${D}" -rC "${S}"/tools install
}
