# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Set of tools for creating TeX documents with graphics"
HOMEPAGE="https://www.xfig.org/"

if [[ ${PV} == 9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/mcj/fig2dev"
else
	SRC_URI="https://downloads.sourceforge.net/mcj/${P}.tar.xz
		mirror://gentoo/fig2mpdf-1.1.2.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
fi

SRC_URI+=" mirror://gentoo/fig2mpdf-1.1.2.tar.bz2"

LICENSE="BSD"
SLOT="0"
IUSE="+ghostscript test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( ghostscript )"

DEPEND="
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	virtual/zlib:=
	x11-apps/rgb
	x11-libs/libXpm
"
RDEPEND="
	${DEPEND}
	app-text/poppler
	media-libs/netpbm
	ghostscript?
	(
		app-text/ghostscript-gpl
		virtual/imagemagick-tools[jpeg,png,postscript,tiff]
	)
"
BDEPEND="
	app-text/rman
"

DOCS=( README CHANGES NOTES )
HTML_DOCS=( "${WORKDIR}/fig2mpdf/doc/." )

PATCHES=(
	"${FILESDIR}/${P}-prototypes.patch"
	"${FILESDIR}/${P}-imagemagick.patch"
)

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi

	# Unpack fig2mpdf for live ebuilds also
	default
}

src_prepare() {
	default

	if [[ ${PV} == 9999 ]]; then
		eautoreconf
	fi
}

src_configure() {
	econf --enable-transfig
}

src_compile() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
		CDEBUGFLAGS="${CFLAGS}"
		LOCAL_LDFLAGS="${LDFLAGS}"
		USRLIBDIR="${EPREFIX}/usr/$(get_libdir)"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	local myemakeargs=(
		DESTDIR="${D}"
		INSTDATFLAGS="-m 644"
		INSTMANFLAGS="-m 644"
	)
	emake "${myemakeargs[@]}" install

	dobin "${WORKDIR}/fig2mpdf/fig2mpdf"
	doman "${WORKDIR}/fig2mpdf/fig2mpdf.1"

	einstalldocs

	rm "${ED}/usr/share/doc/${PF}/html/"{Makefile,*.lfig,*.pdf,*.tex} || die
}
