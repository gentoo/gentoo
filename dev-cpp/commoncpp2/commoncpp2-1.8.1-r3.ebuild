# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="C++ library offering portable support for system-related services"
SRC_URI="mirror://gnu/commoncpp/${P}.tar.gz"
HOMEPAGE="https://www.gnu.org/software/commoncpp/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~x86"
IUSE="debug doc examples ipv6 gnutls ssl static-libs"

RDEPEND="
	sys-libs/zlib
	ssl? (
		gnutls? (
			dev-libs/libgcrypt:0=
			net-libs/gnutls:=
		)
		!gnutls? ( dev-libs/openssl:0= )
	)"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.3.6 )"

HTML_DOCS=()

PATCHES=(
	"${FILESDIR}/1.8.1-configure_detect_netfilter.patch"
	"${FILESDIR}/1.8.0-glibc212.patch"
	"${FILESDIR}/1.8.1-autoconf-update.patch"
	"${FILESDIR}/1.8.1-fix-buffer-overflow.patch"
	"${FILESDIR}/1.8.1-parallel-build.patch"
	"${FILESDIR}/1.8.1-libgcrypt.patch"
	"${FILESDIR}/1.8.1-fix-c++14.patch"
	"${FILESDIR}/1.8.1-gnutls-3.4.patch"
)

pkg_setup() {
	use doc && HTML_DOCS+=( doc/html/. )
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use ssl && local myconf=( $(usex gnutls '--with-gnutls' '--with-openssl') )

	econf \
		$(use_enable debug) \
		$(use_with ipv6) \
		$(use_enable static-libs static) \
		$(use_with doc doxygen) \
		"${myconf[@]}"
}

src_install () {
	default
	prune_libtool_files

	dodoc COPYING.addendum

	if use examples; then
		docinto examples
		dodoc demo/{*.cpp,*.h,*.xml,README}
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
