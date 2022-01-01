# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature xdg-utils

DESCRIPTION="Program for improving image files made with a digital camera"
HOMEPAGE="https://kornelix.net/fotoxx20/fotoxx.html"
SRC_URI="https://kornelix.net/downloads/downloads/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

# For required dependencies read doc/README, for required tools read
# data/userguide [INSTALLATION]. xdg-open (x11-misc/xdg-utils) is an
# alternative to firefox and chromium-browser. `grep '"which ' * -R`
# is helpful to report some required tools run via the shell.

DEPEND="
	media-libs/clutter
	media-libs/clutter-gtk
	media-libs/lcms:2
	media-libs/libpng:0
	media-libs/tiff:0
	media-libs/libchamplain[gtk]
	virtual/jpeg
	x11-libs/gtk+:3"
RDEPEND="
	${DEPEND}
	media-gfx/dcraw
	media-libs/exiftool
	x11-misc/xdg-utils
"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}/${PN}-21.40-documentation.patch" )

DOCS=()
HTML_DOCS=()

src_prepare() {
	sed -i -e "/^DOCDIR/ s/${PN}$/${PF}/" Makefile || die
	default
}

src_install() {
	# For the Help menu items to work, *.html must be in /usr/share/doc/${PF},
	# and README, changelog, copyright, license, etc. must not be compressed.
	emake DESTDIR="${D}" install
	rm -f "${D}"/usr/share/doc/${PF}/*.man || die
	docompress -x /usr/share/doc
}

pkg_postinst() {
	optfeature "HEIC file support" media-libs/libheif
	optfeature "additional RAW file support" media-gfx/rawtherapee
	optfeature "additional RAW file support" media-gfx/darktable
	optfeature "video thumbnails & playback" media-video/ffmpeg
	optfeature "copying images to optical media" app-cdr/dvd+rw-tools
	optfeature "additional panorama support" media-gfx/hugin
	optfeature "WEBP file support" media-libs/libwebp

	elog
	elog "Please read the Help > User Guide for details. The source location is"
	elog "/usr/share/fotoxx/data/userguide and after running fotoxx a copy will"
	elog "be placed at /home/<user>/.fotoxx/userguide."
	elog
	elog "To play videos, in Tools > Preferences set 'Video File Play Command'."
	elog
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
