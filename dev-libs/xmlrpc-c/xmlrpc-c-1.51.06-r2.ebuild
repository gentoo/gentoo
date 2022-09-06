# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

# Upstream maintains 3 release channels: http://xmlrpc-c.sourceforge.net/release.html
# 1. Only the "Super Stable" series is released as a tarball
# 2. SVN tagging of releases seems spotty: http://svn.code.sf.net/p/xmlrpc-c/code/release_number/
# Because of this, we are following the "Super Stable" release channel

DESCRIPTION="A lightweight RPC library based on XML and HTTP"
HOMEPAGE="http://xmlrpc-c.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0/4.51"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="abyss +cgi +curl +cxx +libxml2 threads test"

RESTRICT="!test? ( test )"

REQUIRED_USE="test? ( abyss curl cxx )"

RDEPEND="
	sys-libs/ncurses:0=[${MULTILIB_USEDEP}]
	sys-libs/readline:0=[${MULTILIB_USEDEP}]
	curl? ( net-misc/curl[${MULTILIB_USEDEP}] )
	libxml2? ( dev-libs/libxml2[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

pkg_setup() {
	use curl || ewarn "Curl support disabled: No client library will be built"
}

src_prepare() {
	sed -i \
		-e "/CFLAGS_COMMON/s|-g -O3$||" \
		-e "/CXXFLAGS_COMMON/s|-g$||" \
		common.mk || die

	default

	# Out-of-source install phase is broken
	multilib_copy_sources
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
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

multilib_src_compile() {
	default_src_compile
	# Tools building is broken in this release
	#multilib_is_native_abi && use tools && emake -rC "${S}"/tools
}

multilib_src_test() {
	# Needed for tests, bug #836469
	cp "${BUILD_DIR}"/include/xmlrpc-c/config.h "${S}"/include/xmlrpc-c || die
	default_src_test
}

#multilib_src_install_all() {
#	# Tools building is broken in this release
#	#use tools && emake DESTDIR="${D}" -rC "${S}"/tools install
#}
