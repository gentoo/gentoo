# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="xml(+)"
inherit distutils-r1 xdg

MY_PV="${PV/_/-}"
DESCRIPTION="A simple audiofile converter application for the GNOME environment"
HOMEPAGE="https://soundconverter.org/"
SRC_URI="https://github.com/kassoulet/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="aac flac mp3 ogg opus vorbis"

# gst-plugins-meta for any decoders, USE flags for specific encoders used by code
# List in soundconverter/gstreamer.py
# wavenc and mp4mux come from gst-plugins-good, which everyone having base should have, so unconditional
RDEPEND="
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	x11-libs/pango[introspection]
	$(python_gen_cond_dep '
		dev-python/gst-python[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
	')
	media-libs/gst-plugins-base:1.0[vorbis?,ogg?]
	media-plugins/gst-plugins-meta:1.0
	flac? ( media-plugins/gst-plugins-flac:1.0 )
	media-libs/gst-plugins-good:1.0
	mp3? (
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-ugly:1.0
		media-plugins/gst-plugins-lame:1.0
	)
	aac? ( media-plugins/gst-plugins-faac:1.0 )
	opus? (	media-plugins/gst-plugins-opus:1.0 )
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	')
"

python_prepare_all() {
	distutils-r1_python_prepare_all
	rm -v "${S}/CHANGELOG.old"
	# workaround incorrect behavior when LINGUAS is set to an empty string
	# https://bugs.launchpad.net/python-distutils-extra/+bug/1133594
	! [[ -v LINGUAS && -z ${LINGUAS} ]] || rm po/*.po || die
}

python_install_all() {
	rm -v "${D}/usr/share/glib-2.0/schemas/gschemas.compiled"
	mv -v "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${P}"
	distutils-r1_python_install_all
}
