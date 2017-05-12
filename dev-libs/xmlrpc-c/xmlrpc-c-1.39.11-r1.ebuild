# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Upstream maintains 3 release channels: http://xmlrpc-c.sourceforge.net/release.html
# 1. Only the "Super Stable" series is released as a tarball
# 2. SVN tagging of releases seems spotty: http://svn.code.sf.net/p/xmlrpc-c/code/release_number/
# Because of this, we are following the "Super Stable" release channel

DESCRIPTION="A lightweigt RPC library based on XML and HTTP"
HOMEPAGE="http://xmlrpc-c.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="abyss +cgi +curl +cxx +libxml2 threads test tools"

REQUIRED_USE="test? ( abyss curl cxx ) tools? ( curl )"

DEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	curl? ( net-misc/curl )
	libxml2? ( dev-libs/libxml2 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.32.05-Wimplicit.patch"
	"${FILESDIR}/${P}-cplusplus.patch"
)

pkg_setup() {
	use curl || ewarn "Curl support disabled: No client library will be built"
}

src_prepare() {
	sed -i \
		-e "/CFLAGS_COMMON/s|-g -O3$||" \
		-e "/CXXFLAGS_COMMON/s|-g$||" \
		common.mk || die

	eapply ${PATCHES[@]}
	eapply_user
}

src_configure() {
	econf \
		--disable-wininet-client \
		--disable-libwww-client \
		--without-libwww-ssl  \
		$(use_enable libxml2 libxml2-backend) \
		$(use_enable threads abyss-threads) \
		$(use_enable cgi cgi-server) \
		$(use_enable abyss abyss-server) \
		$(use_enable cxx cplusplus) \
		$(use_enable curl curl-client)
}

src_compile() {
	# Parallel builds are fixed in v 1.43.x or newer
	emake -j1
	use tools && emake -rC "${S}"/tools
}

src_install() {
	default
	use tools && emake DESTDIR="${D}" -rC "${S}"/tools install
}
