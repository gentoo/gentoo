# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool multilib-minimal

# Note: Please bump this in sync with dev-libs/libxml2.
DESCRIPTION="XSLT libraries and tools"
HOMEPAGE="http://www.xmlsoft.org/ https://gitlab.gnome.org/GNOME/libxslt"
SRC_URI="ftp://xmlsoft.org/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="crypt debug examples static-libs elibc_Darwin"

BDEPEND=">=virtual/pkgconfig-1"
RDEPEND="
	>=dev-libs/libxml2-2.9.10:2[${MULTILIB_USEDEP}]
	crypt? ( >=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/xslt-config
)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libxslt/xsltconfig.h
)

src_prepare() {
	default

	DOCS=( AUTHORS ChangeLog FEATURES NEWS README TODO )

	# Prefix always needs elibtoolize if not eautoreconf'd.
	elibtoolize
}

multilib_src_configure() {
	# Python bindings were dropped as they were Python 2 only at the time
	ECONF_SOURCE="${S}" econf \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-html-subdir=html \
		--without-python \
		$(use_with crypt crypto) \
		$(use_with debug) \
		$(use_with debug mem-debug) \
		$(use_enable static-libs static) \
		"$@"
}

multilib_src_install() {
	# "default" does not work here - docs are installed by multilib_src_install_all
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -type f -name "*.la" -delete || die
}
