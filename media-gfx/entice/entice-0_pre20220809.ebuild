# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature xdg

MY_COMMIT="5122896d812a2db0fd2c536f047ac340fd1d12e5"

DESCRIPTION="A simple image viewer based on EFL"
HOMEPAGE="https://git.enlightenment.org/vtorri/entice https://github.com/vtorri/entice"
SRC_URI="https://github.com/vtorri/entice/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="|| ( dev-libs/efl[X] dev-libs/efl[wayland] )
	media-libs/libexif"
RDEPEND="${DEPEND}"

S="${WORKDIR}/entice-${MY_COMMIT}"

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header "Image format support:"
	optfeature "avif support" dev-libs/efl[avif]
	optfeature "bmp,wbmp support" dev-libs/efl[bmp]
	optfeature "dds support" dev-libs/efl[dds]
	optfeature "gif support" dev-libs/efl[gif]
	optfeature "heif support" dev-libs/efl[heif]
	optfeature "ico,cur support" dev-libs/efl[ico]
	optfeature "jp2k support" dev-libs/efl[jpeg2k]
	optfeature "pdf support" dev-libs/efl[pdf]
	optfeature "pmaps support" dev-libs/efl[pmaps]
	optfeature "psd support" dev-libs/efl[psd]
	optfeature "raw support" dev-libs/efl[raw]
	optfeature "svg,rsvg support" dev-libs/efl[svg]
	optfeature "tga support" dev-libs/efl[tga]
	optfeature "tgv support" dev-libs/efl[tgv]
	optfeature "tiff support" dev-libs/efl[tiff]
	optfeature "webp support" dev-libs/efl[webp]
	optfeature "xcf support" dev-libs/efl[xcf]
	optfeature "xpm support" dev-libs/efl[xpm]
}
