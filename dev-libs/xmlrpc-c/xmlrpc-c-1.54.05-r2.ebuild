# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

# Upstream maintains 3 release channels: http://xmlrpc-c.sourceforge.net/release.html
# 1. Only the "Super Stable" series is released as a tarball
# 2. SVN tagging of releases seems spotty: http://svn.code.sf.net/p/xmlrpc-c/code/release_number/
# Because of this, we are following the "Super Stable" release channel

DESCRIPTION="A lightweight RPC library based on XML and HTTP"
HOMEPAGE="http://xmlrpc-c.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0/4.54"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="abyss +cgi +curl +cxx +libxml2 threads test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( abyss curl cxx )"

RDEPEND="
	sys-libs/ncurses:=
	sys-libs/readline:=
	curl? ( net-misc/curl )
	libxml2? ( dev-libs/libxml2 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

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

	# Tools building is broken in this release
	#use tools && emake DESTDIR="${D}" -rC "${S}"/tools install
}
