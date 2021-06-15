# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="C++ library offering portable support for system-related services"
HOMEPAGE="https://www.gnu.org/software/commoncpp/"
SRC_URI="
	mirror://gnu/commoncpp/${P}.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${P}-patches.txz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="debug doc examples gnutls ipv6 ssl"

RDEPEND="
	sys-libs/zlib:=
	ssl? (
		gnutls? (
			dev-libs/libgcrypt:0=
			net-libs/gnutls:=
		)
		!gnutls? (
			dev-libs/openssl:0=
		)
	)"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( >=app-doc/doxygen-1.3.6 )"

PATCHES=(
	"${WORKDIR}"/patches/1.8.1-configure_detect_netfilter.patch
	"${WORKDIR}"/patches/1.8.1-glibc212.patch
	"${WORKDIR}"/patches/1.8.1-autoconf-update.patch
	"${WORKDIR}"/patches/1.8.1-fix-buffer-overflow.patch
	"${WORKDIR}"/patches/1.8.1-parallel-build.patch
	"${WORKDIR}"/patches/1.8.1-libgcrypt.patch
	"${WORKDIR}"/patches/1.8.1-fix-c++14.patch
	"${WORKDIR}"/patches/1.8.1-gnutls-3.4.patch
	"${WORKDIR}"/patches/1.8.1-fix-gcc9.patch
	"${WORKDIR}"/patches/1.8.1-c++17.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable debug) \
		$(use_with ipv6) \
		$(use_with ssl $(usex gnutls gnutls openssl)) \
		$(use_with doc doxygen)
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default

	# package provides .pc files
	find "${ED}" -name '*.la' -delete || die

	dodoc COPYING.addendum

	if use examples; then
		docinto examples
		dodoc demo/{*.cpp,*.h,*.xml,README}
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
