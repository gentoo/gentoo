# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Network simulation tool"
HOMEPAGE="https://www.csse.uwa.edu.au/cnet3/"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	>=dev-lang/tk-8.5
	dev-libs/elfutils
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

DOCS=( 1st.README )

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.4-gentoo.patch
	"${FILESDIR}"/${PN}-3.3.1-tcl.patch
)

src_prepare() {
	# Set libdir properly
	sed -i -e "/CNETPATH/s:local/lib:$(get_libdir):" src/preferences.h || die
	sed -i -e "/^LIBDIR/s:lib:$(get_libdir):" Makefile || die

	default
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		C99="$(tc-getCC) -std=c99" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)"
}

src_install() {
	default

	if use examples; then
		dodoc -r examples
	fi
}
