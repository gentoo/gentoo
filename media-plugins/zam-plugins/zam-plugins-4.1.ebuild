# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DPF_COMMIT="88180608a206b529fcb660d406ddf6f934002806"
PUGL_COMMIT="844528e197c51603f6cef3238b4a48d23bf60eb7"
DPF_P="DPF-${DPF_COMMIT}"
PUGL_P="pugl-${PUGL_COMMIT}"

DESCRIPTION="Collection of LV2/LADSPA/VST/JACK audio plugins for high quality processing"
HOMEPAGE="https://www.zamaudio.com/ https://github.com/zamaudio/zam-plugins"
SRC_URI="https://github.com/zamaudio/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/DISTRHO/DPF/archive/${DPF_COMMIT}.tar.gz -> ${DPF_P}.tar.gz
	https://github.com/DISTRHO/pugl/archive/${PUGL_COMMIT}.tar.gz -> ${PUGL_P}.tar.gz"

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

zam_emake() {
	emake PREFIX=/usr LIBDIR=$(get_libdir) VERBOSE=true \
		BASE_OPTS="" SKIP_STRIPPING=true \
		HAVE_ZITA_CONVOLVER=true \
		HAVE_CAIRO=$(usex opengl true false) \
		HAVE_DGL=$(usex opengl true false) \
		HAVE_OPENGL=$(usex opengl true false) \
		UI_TYPE=$(usex opengl "opengl" "none") \
		HAVE_JACK=$(usex jack true false) \
		${@}
}

src_prepare() {
	default

	rm -rf dpf
	ln -s "${WORKDIR}"/${DPF_P} dpf || die "Failed to create DPF symlink"
	rm -rf dpf/dgl/src/pugl-upstream
	ln -s "${WORKDIR}"/${PUGL_P} dpf/dgl/src/pugl-upstream || die "Failed to create pugl symlink"

	# To make absolutely sure we do not even accidentally use bundled libs
	rm -rf lib
}

src_compile() {
	zam_emake
}

src_install() {
	zam_emake DESTDIR="${ED}" install
}
