# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edo

DESCRIPTION="Interpreter for Psion 5(MX) file formats"
HOMEPAGE="https://frodo.looijaard.name/project/psiconv"
SRC_URI="https://frodo.looijaard.name/system/files/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="+imagemagick"

# TIFF is the output by default for input image formats
RDEPEND="imagemagick? ( media-gfx/imagemagick:=[cxx,tiff] )"
DEPEND="${RDEPEND}"
BDEPEND="app-alternatives/bc"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.3-gcc10-fno-common.patch
	"${FILESDIR}"/${PN}-0.9.9-fix_getopt.patch
	"${FILESDIR}"/${PN}-0.9.9-fix_imagemagick.patch
)

src_prepare() {
	default

	# use patched configure.in, then modernize the build system
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		MAGICKCONFIG="Magick++-config"
		$(use_with imagemagick)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	# test various encodings and output formats
	# anyway the html doc is already generated with the freshly compiled binary
	for file in Word TextEd; do
		for e in UTF8 UCS2 ASCII; do
			edo program/psiconv/psiconv examples/${file} -n 3 -e ${e} -T XHTML -o "${T}"/${file}-${e}.out
		done
	done
	if use imagemagick; then
		for file in Sketch Clipart MBM; do
			edo program/psiconv/psiconv examples/${file} -n 3 -T TIFF -o "${T}"/${file}.out
		done
	fi
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die

	# move html in the docdir and remove source files
	mv "${ED}"/usr/share/psiconv/xhtml "${ED}"/usr/share/doc/${PF}/html || die
	rm -r "${ED}"/usr/share/psiconv || die
}
