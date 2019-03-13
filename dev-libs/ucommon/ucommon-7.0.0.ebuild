# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Portable C++ runtime for threads and sockets"
HOMEPAGE="https://www.gnu.org/software/commoncpp"
SRC_URI="mirror://gnu/commoncpp/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/8" # soname version
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux"
IUSE="doc static-libs +cxx debug libressl ssl gnutls"

RDEPEND="
	ssl? (
		gnutls? (
			net-libs/gnutls:0=
			dev-libs/libgcrypt:0=
		)
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

DOCS=(README NEWS SUPPORT ChangeLog AUTHORS)

PATCHES=(
	"${FILESDIR}/${PN}-6.0.3-install_gcrypt.m4_file.patch"
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
	local myconf=""
	if use ssl; then
		myconf+=" --with-sslstack=$(usex gnutls gnu ssl) "
	else
		myconf+=" --with-sslstack=nossl ";
	fi

	local myeconfargs=(
		$(use_enable cxx stdcpp)
		${myconf}
		--enable-atomics
		--with-pkg-config
	)
	econf "${myeconfargs}"
}

src_compile() {
	default
	use doc && emake doxy
}

src_install() {
	use doc && HTML_DOCS="doc/html/*"
	default
}
