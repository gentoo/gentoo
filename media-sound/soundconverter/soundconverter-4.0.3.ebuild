# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="xml(+)"
inherit gnome2-utils distutils-r1 virtualx xdg

MY_PV="${PV/_/-}"
DESCRIPTION="A simple audiofile converter application for the GNOME environment"
HOMEPAGE="https://soundconverter.org/"
SRC_URI="https://github.com/kassoulet/${PN}/archive/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
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
	test? (
		media-plugins/gst-plugins-flac:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-ugly:1.0
		media-plugins/gst-plugins-lame:1.0
		media-plugins/gst-plugins-faac:1.0
		media-plugins/gst-plugins-opus:1.0
	)
"

# Before PEP517: tests seem to hang and also fail to find fdkaacenc from gst?
# After: need to trick it into finding the data (inc. glade files)
RESTRICT="test"

python_prepare_all() {
	gnome2_environment_reset
	distutils-r1_python_prepare_all

	rm -v "${S}/CHANGELOG.old" || die

	# workaround incorrect behavior when LINGUAS is set to an empty string
	# https://bugs.launchpad.net/python-distutils-extra/+bug/1133594
	! [[ -v LINGUAS && -z ${LINGUAS} ]] || rm po/*.po || die
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	export GSETTINGS_SCHEMA_DIR="${S}/data"
	"${BROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}"/data || die

	"${EPYTHON}" tests/test.py || die
}

python_install_all() {
	rm -v "${ED}"/usr/share/glib-2.0/schemas/gschemas.compiled || die
	mv -v "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/doc/${PF} || die
	distutils-r1_python_install_all
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
