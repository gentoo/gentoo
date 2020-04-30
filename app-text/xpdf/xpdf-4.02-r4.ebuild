# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop xdg

DESCRIPTION="The PDF viewer and tools"
HOMEPAGE="https://www.xpdfreader.com"
SRC_URI="https://xpdfreader-dl.s3.amazonaws.com/${P}.tar.gz
	i18n? (
		https://xpdfreader-dl.s3.amazonaws.com/xpdf-arabic.tar.gz
		https://xpdfreader-dl.s3.amazonaws.com/xpdf-chinese-simplified.tar.gz
		https://xpdfreader-dl.s3.amazonaws.com/xpdf-chinese-traditional.tar.gz
		https://xpdfreader-dl.s3.amazonaws.com/xpdf-cyrillic.tar.gz
		https://xpdfreader-dl.s3.amazonaws.com/xpdf-greek.tar.gz
		https://xpdfreader-dl.s3.amazonaws.com/xpdf-hebrew.tar.gz
		https://xpdfreader-dl.s3.amazonaws.com/xpdf-japanese.tar.gz
		https://xpdfreader-dl.s3.amazonaws.com/xpdf-korean.tar.gz
		https://xpdfreader-dl.s3.amazonaws.com/xpdf-latin2.tar.gz
		https://xpdfreader-dl.s3.amazonaws.com/xpdf-thai.tar.gz
		https://xpdfreader-dl.s3.amazonaws.com/xpdf-turkish.tar.gz
	)"

LICENSE="GPL-2 GPL-3 i18n? ( BSD )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cmyk cups +fontconfig i18n icons +libpaper metric opi png +textselect utils"

BDEPEND="
	icons? ( media-gfx/inkscape )
"
DEPEND="
	cups? (
		dev-qt/qtprintsupport:5[cups]
		net-print/cups
	)
	fontconfig? ( media-libs/fontconfig )
	libpaper? ( app-text/libpaper )
	utils? ( png? ( media-libs/libpng:0 ) )
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/freetype
	sys-libs/zlib
"
RDEPEND="${DEPEND}
	dev-qt/qtsvg:5
	media-fonts/urw-fonts
"

PATCHES=(
	"${FILESDIR}"/${PN}-automagic.patch
	"${FILESDIR}"/${PN}-visibility.patch
	"${FILESDIR}"/${PN}-shared-libs.patch
	"${FILESDIR}"/${PN}-CVE-2019-17064.patch
)

src_prepare() {
	sed -i \
		"s|/usr/local/etc|${EPREFIX}/etc|;
		 s|/usr/local|${EPREFIX}/usr|" \
		doc/sample-xpdfrc || die

	if use i18n; then
		sed -i "s|/usr/local|${EPREFIX}/usr|" "${WORKDIR}"/*/add-to-xpdfrc || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DA4_PAPER=$(usex metric)
		-DNO_FONTCONFIG=$(usex fontconfig off on)
		-DNO_TEXT_SELECT=$(usex textselect off on)
		-DOPI_SUPPORT=$(usex opi)
		-DSPLASH_CMYK=$(usex cmyk)
		-DWITH_LIBPAPER=$(usex libpaper)
		-DWITH_LIBPNG=$(usex png)
		-DXPDFWIDGET_PRINTING=$(usex cups)
		-DSYSTEM_XPDFRC="${EPREFIX}/etc/xpdfrc"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use icons; then
		local inkarg="-e"
		has_version -b '>media-gfx/inkscape-0.99' && inkarg="-o"

		sizes="16 22 24 32 36 48 64 72 96 128 192 256 512"
		cd xpdf-qt
		mkdir $sizes
		local i
		for i in $sizes; do
			inkscape xpdf-icon.svg -w $i -h $i $inkarg $i/xpdf.png
		done
	fi
}

src_install() {
	cmake-utils_src_install

	domenu "${FILESDIR}/xpdf.desktop"
	newicon -s scalable xpdf-qt/xpdf-icon.svg xpdf.svg
	if use icons; then
		local i
		for i in $sizes; do
			doicon -s $i xpdf-qt/$i/xpdf.png
		done
		unset sizes
	fi

	insinto /etc
	newins doc/sample-xpdfrc xpdfrc

	local d i
	if use utils; then
		for d in "bin" "share/man/man1"; do
			pushd "${ED}/usr/${d}" || die
			for i in pdf*; do
				mv "${i}" "x${i}" || die
			done
			popd || die
		done

		einfo "PDF utilities were renamed from pdf* to xpdf* to avoid file collisions"
		einfo "with other packages"
	else
		rm -rf "${ED}"/usr/bin/pdf* \
			   "${ED}"/usr/share/man/man1/pdf* \
			   "${ED}"/usr/$(get_libdir) || die
	fi

	if use i18n; then
		for i in arabic chinese-simplified chinese-traditional cyrillic greek \
				 hebrew japanese korean latin2 thai turkish; do
			insinto "/usr/share/xpdf/${i}"
			doins -r $(find -O3 "${WORKDIR}/xpdf-${i}" -maxdepth 1 -mindepth 1 \
				! -name README ! -name add-to-xpdfrc || die)

			cat "${WORKDIR}/xpdf-${i}/add-to-xpdfrc" >> "${ED}/etc/xpdfrc" || die
		done
	fi
}
