# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Tool for conversion of MSWord doc and rtf files to something readable"
HOMEPAGE="http://wvware.sourceforge.net/"
SRC_URI="http://abiword.org/downloads/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
IUSE="tools wmf"

RDEPEND="
	>=dev-libs/glib-2:2
	>=gnome-extra/libgsf-1.13:=
	sys-libs/zlib
	media-libs/libpng:0=
	dev-libs/libxml2:2
	tools? (
		app-text/texlive-core
		dev-texlive/texlive-latex
	)
	wmf? ( >=media-libs/libwmf-0.2.2 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-C99-decls.patch
	"${FILESDIR}"/${P}-gcc14-build-fix.patch
	"${FILESDIR}"/${P}-gsf-doc-meta-data.patch
)

src_prepare() {
	default

	# remove -ansi flag, since it disables POSIX
	# function declarations (bug #874396)
	sed -i -e 's/-ansi//' configure || die

	if ! use tools; then
		sed -i -e '/bin_/d' GNUmakefile.am || die
		sed -i -e '/SUBDIRS/d' GNUmakefile.am || die
		sed -i -e '/\/GNUmakefile/d' configure.ac || die
		sed -i -e '/wv[[:upper:]]/d' configure.ac || die
		sed -i -e 's/-ansi//' configure.ac || die

		# automake-1.13 fix, bug #467620
		sed -i -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' configure.ac || die

		eautoreconf
	fi
}

src_configure() {
	econf $(use_with wmf libwmf)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	rm -f "${ED}"/usr/share/man/man1/wvConvert.1 || die
	use tools && dosym wvWare.1 /usr/share/man/man1/wvConvert.1
}
