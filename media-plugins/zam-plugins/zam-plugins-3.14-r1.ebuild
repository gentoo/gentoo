# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DPF_COMMIT="9243625aacb9fb8dd9fe4bd479b227149eb37959"
DPF_P="DPF-${DPF_COMMIT}"

DESCRIPTION="Collection of LV2/LADSPA/VST/JACK audio plugins for high quality processing"
HOMEPAGE="http://www.zamaudio.com/ https://github.com/zamaudio/zam-plugins"
SRC_URI="https://github.com/zamaudio/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/DISTRHO/DPF/archive/${DPF_COMMIT}.tar.gz -> ${DPF_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="jack opengl"

DEPEND="media-libs/ladspa-sdk
	media-libs/liblo
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/lv2
	media-libs/zita-convolver
	sci-libs/fftw:3.0
	x11-libs/libX11
	jack? ( virtual/jack )
	opengl? (
		media-libs/libglvnd[X]
		x11-libs/cairo[X]
	)"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	rm -rf dpf
	ln -s ../${DPF_P} dpf || die "Failed to create DPF symlink"

	# To make absolutely sure we do not even accidentally use bundled libs
	rm -rf lib
}

src_compile() {
	emake PREFIX=/usr LIBDIR=$(get_libdir) VERBOSE=true \
		BASE_OPTS="" SKIP_STRIPPING=true \
		HAVE_ZITA_CONVOLVER=true \
		HAVE_CAIRO=$(usex opengl true false) \
		HAVE_DGL=$(usex opengl true false) \
		HAVE_OPENGL=$(usex opengl true false) \
		UI_TYPE=$(usex opengl "opengl" "none") \
		HAVE_JACK=$(usex jack true false)
}

src_install() {
	emake PREFIX=/usr LIBDIR=$(get_libdir) VERBOSE=true \
		BASE_OPTS="" SKIP_STRIPPING=true \
		HAVE_ZITA_CONVOLVER=true \
		HAVE_CAIRO=$(usex opengl true false) \
		HAVE_DGL=$(usex opengl true false) \
		HAVE_OPENGL=$(usex opengl true false) \
		UI_TYPE=$(usex opengl "opengl" "none") \
		HAVE_JACK=$(usex jack true false) \
		DESTDIR="${ED}" install
}
