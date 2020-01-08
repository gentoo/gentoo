# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="C++ library offering portable support for system-related services"
HOMEPAGE="https://www.gnu.org/software/commoncpp/"
SRC_URI="mirror://gnu/commoncpp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="debug doc examples gnutls ipv6 libressl ssl static-libs"

RDEPEND="
	sys-libs/zlib:=
	ssl? (
		gnutls? (
			dev-libs/libgcrypt:0=
			net-libs/gnutls:=
		)
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.3.6 )"

PATCHES=(
	"${FILESDIR}/1.8.1-configure_detect_netfilter.patch"
	"${FILESDIR}/1.8.0-glibc212.patch"
	"${FILESDIR}/1.8.1-autoconf-update.patch"
	"${FILESDIR}/1.8.1-fix-buffer-overflow.patch"
	"${FILESDIR}/1.8.1-parallel-build.patch"
	"${FILESDIR}/1.8.1-libgcrypt.patch"
	"${FILESDIR}/1.8.1-fix-c++14.patch"
	"${FILESDIR}/1.8.1-gnutls-3.4.patch"
	"${FILESDIR}/1.8.1-libressl.patch" # bug 674416
	"${FILESDIR}/1.8.1-fix-gcc9.patch" # bug 686012
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_with ipv6) \
		$(use_with ssl $(usex gnutls gnutls openssl)) \
		$(use_enable static-libs static) \
		$(use_with doc doxygen)
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die

	dodoc COPYING.addendum

	if use examples; then
		docinto examples
		dodoc demo/{*.cpp,*.h,*.xml,README}
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
