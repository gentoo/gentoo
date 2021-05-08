# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Portable C++ runtime for threads and sockets"
HOMEPAGE="https://www.gnu.org/software/commoncpp"
SRC_URI="mirror://gnu/commoncpp/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/8" # soname version
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux"
IUSE="doc +cxx debug ssl gnutls"

RDEPEND="
	ssl? (
		net-libs/gnutls:=
		dev-libs/libgcrypt:=
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.3-install_gcrypt.m4_file.patch
	"${FILESDIR}"/${PN}-7.0.0-c++17-dynamic-exception-specifications.patch
)

src_prepare() {
	default

	# Aclocal 1.13 deprecated error BGO #467674
	sed -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' -i configure.ac || die

	# don't install latex and rtf documents
	sed -e '/^GENERATE_LATEX/s@YES@NO@' -e '/^GENERATE_RTF/s@YES@NO@' \
		-i Doxyfile.in || die

	eautoreconf
}

src_configure() {
	# https://bugs.gentoo.org/730018
	# need to link GCC's libatomic when compiling with clang
	append-libs -latomic

	local myeconfargs=(
		--disable-static
		--with-pkg-config
		# don't bother with openssl, incompatible with the 1.1 API
		--with-sslstack=$(usex ssl gnu nossl)
		$(use_enable cxx stdcpp)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use doc; then
		emake doxy
		HTML_DOCS=( doc/html/. )
	fi
}

src_install() {
	default
	dodoc SUPPORT

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
