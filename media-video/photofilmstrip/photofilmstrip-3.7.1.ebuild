# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite"
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 eutils xdg-utils

DESCRIPTION="Movie slideshow creator using Ken Burns effect"
HOMEPAGE="https://www.photofilmstrip.org/en/ https://github.com/PhotoFilmStrip"
SRC_URI="https://github.com/PhotoFilmStrip/PFS/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-python/gst-python[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/wxpython:4.0[${PYTHON_USEDEP}]
	media-plugins/gst-plugins-jpeg:1.0
	x11-libs/wxGTK:*[X]"
DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}/${P}-disable-docs-by-default.patch" )

src_prepare() {
	default

	# fix 'unexpected path' QA warning on einstalldocs
	sed -i 's|"share", "doc", "photofilmstrip"|"share", "doc", "'${PF}'"|g' setup.py ||
	die "Fixing unexpected path failed."

	# build html docs
	if use doc; then
		sed -i 's/Sphinx = None/from sphinx.application import Sphinx/g' -i setup.py ||
		die "Failed to enable building docs with sphinx."
	fi

	# fix a QA issue with .desktop file
	sed -i '/Version=/d' data/photofilmstrip.desktop || die "Failed to update .desktop file."
}

python_install_all() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/sphinx/html/. )
	doman docs/manpage/*.1
	distutils-r1_python_install_all
}

pkg_postinst() {
	xdg_icon_cache_update

	optfeature "additional rendering formats" media-plugins/gst-plugins-bad
	optfeature "additional rendering formats" media-plugins/gst-plugins-good
	optfeature "additional rendering formats" media-plugins/gst-plugins-ugly
	optfeature "ogg/theora support" media-libs/gst-plugins-base[theora]
	optfeature "h264 (MKV/MP4) support" media-plugins/gst-plugins-x264
	optfeature "h265 (MKV) support" media-plugins/gst-plugins-x265
	optfeature "MPEG 1/2 (DVD) support" media-plugins/gst-plugins-mpeg2enc
}

pkg_postrm() {
	xdg_icon_cache_update
}
