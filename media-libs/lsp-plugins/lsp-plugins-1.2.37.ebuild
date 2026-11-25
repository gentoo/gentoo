# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs xdg

DESCRIPTION="Linux Studio Plugins"
HOMEPAGE="https://lsp-plug.in"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lsp-plugins/lsp-plugins"
	EGIT_BRANCH="devel"
else
	SRC_URI="https://github.com/lsp-plugins/${PN}/releases/download/${PV}/${PN}-src-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="LGPL-3"
SLOT="0"
IUSE="clap doc gstreamer jack ladspa lv2 pipewire standalone test vst2 +vst3 +X"
REQUIRED_USE="
	|| ( clap gstreamer ladspa lv2 standalone vst2 vst3 )
	standalone? ( || ( jack pipewire ) )
"

# Needs wiring up properly
RESTRICT="!test? ( test ) test"

BDEPEND="doc? ( dev-lang/php:* )"
RDEPEND="
	media-libs/libsndfile
	gstreamer? (
		media-libs/gst-plugins-base
		media-libs/gstreamer
	)
	jack? ( virtual/jack )
	lv2? ( x11-libs/cairo )
	pipewire? ( media-video/pipewire:= )
	X? (
		media-libs/fontconfig
		media-libs/freetype
		media-libs/libglvnd[X]
		x11-libs/cairo[X]
		x11-libs/libX11
		x11-libs/libXrandr
	)
"
DEPEND="${RDEPEND}"

# These are dlopen-loaded audio/rendering backends, not linkable libraries.
QA_SONAME="
	usr/lib.*/liblsp-audio-jack-lib-[0-9.]*\.so
	usr/lib.*/liblsp-audio-pipewire-lib-[0-9.]*\.so
	usr/lib.*/liblsp-r3d-glx-lib-[0-9.]*\.so
"

lsp_emake() {
	local myemakeargs=(
		FEATURES="${MODULES[*]}"
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		GSTREAMER_INSTDIR="${EPREFIX}/usr/$(get_libdir)/gstreamer-1.0"

		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		LD="$(tc-getLD)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"

		CFLAGS_EXT="${CFLAGS} ${CPPFLAGS}"
		CXXFLAGS_EXT="${CXXFLAGS} ${CPPFLAGS}"
		LDFLAGS_EXT="${LDFLAGS}"
		VERBOSE=1
	)

	emake "${myemakeargs[@]}" "$@"
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/875833
	#
	# Actually the whole thing is kind of a waste of time. It looks like
	# programs use LDFLAGS, but libraries do not! So some things don't
	# build with LTO, while other things don't build when LTO is enabled.
	# Attempting to build with LTO is just a waste of time and cycles.
	#
	# This was reported upstream but the ticket closed. Abandon hope.
	filter-lto

	MODULES=(
		$(usev clap)
		$(usev doc)
		$(usev gstreamer gst)
		$(usev jack)
		$(usev ladspa)
		$(usev lv2)
		$(usev pipewire)
		$(usev standalone)
		$(usev vst2)
		$(usev vst3)
		$(usev X ui)
	)

	if use standalone && use X; then
		MODULES+=( launcher xdg )
	fi

	local cairo=""
	if use lv2 || use X; then
		cairo="cairo"
	fi
	lsp_emake -j1 config \
		LIBCAIRO_NAME="${cairo}" \
		LIBFONTCONFIG_NAME="$(usev X fontconfig)" \
		LIBFREETYPE_NAME="$(usev X freetype2)" \
		LIBGL_NAME="$(usev X gl)" \
		LIBGSTREAMER_AUDIO_NAME="$(usev gstreamer gstreamer-audio-1.0)" \
		LIBJACK_NAME="$(usev jack)" \
		LIBPIPEWIRE_NAME="$(usev pipewire libpipewire-0.3)" \
		LIBX11_NAME="$(usev X x11)" \
		LIBXRANDR_NAME="$(usev X xrandr)"

	cat >> .config.mk <<-'EOF' || die
		CFLAGS += $(CFLAGS_EXT)
		CXXFLAGS += $(CXXFLAGS_EXT)
		EXE_FLAGS += $(LDFLAGS_EXT)
		SO_FLAGS += $(LDFLAGS_EXT)
	EOF
}

src_compile() {
	lsp_emake
}

src_test() {
	# TODO: wire up tests (https://github.com/lsp-plugins/lsp-plugins#testing)
	:;
}

src_install() {
	lsp_emake DESTDIR="${D}" install
	find "${ED}" \( -name '*.a' -o -name '*.pc' \) -delete || die
}
