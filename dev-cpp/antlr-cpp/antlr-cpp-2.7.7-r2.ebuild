# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

MY_P="${PN%-cpp}-${PV}"

DESCRIPTION="The ANTLR 2 C++ Runtime"
HOMEPAGE="https://www.antlr2.org/"
SRC_URI="https://www.antlr2.org/download/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="public-domain"
SLOT="2"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="doc examples"
RESTRICT="test" # No tests but test target blows up!

BDEPEND="doc? ( app-doc/doxygen[dot] )"

PATCHES=(
	"${FILESDIR}"/${PV}-gcc.patch

	# Upstream only installs a static library. The original antlr ebuild
	# built a shared library manually, which isn't so great either. This
	# ebuild applies libtool instead and therefore an autoreconf is
	# required. A couple of errors concerning tr have been seen but the
	# final result still looks good. This also sidesteps bug #554344 plus
	# the need to call einstall.
	"${FILESDIR}"/${PV}-autotools.patch
)

src_prepare() {
	default

	mv -v {aclocal,acinclude}.m4 || die

	# Delete build files from examples
	find examples -name Makefile.in -delete || die

	eautoreconf
}

multilib_src_configure() {
	CONFIG_SHELL="${BASH}" ECONF_SOURCE="${S}" econf \
		--disable-csharp \
		--disable-examples \
		--disable-java \
		--disable-python \
		--enable-cxx \
		--enable-verbose
}

multilib_src_compile() {
	default

	if multilib_native_use doc; then
		cd "${S}"/lib/cpp || die
		doxygen -u doxygen.cfg || die
		doxygen doxygen.cfg || die
		HTML_DOCS=( "${S}"/lib/cpp/gen_doc/html/. )
	fi
}

multilib_src_install() {
	# We only care about the C++ stuff
	emake -C lib/cpp DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs
	dodoc lib/cpp/AUTHORS lib/cpp/ChangeLog lib/cpp/README lib/cpp/TODO

	if use examples; then
		docinto examples
		dodoc -r examples/cpp/.
	fi

	find "${ED}" -name '*.la' -delete || die
}
