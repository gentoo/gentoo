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
IUSE="doc jack ladspa +lv2 test vst X"
REQUIRED_USE="
	|| ( jack ladspa lv2 )
"
# Needs wiring up properly
RESTRICT="!test? ( test ) test"

BDEPEND="doc? ( dev-lang/php:* )"
DEPEND="
	media-libs/libglvnd[X]
	media-libs/libsndfile
	jack? (
		media-libs/freetype
		virtual/jack
		x11-libs/cairo[X]
		x11-libs/libX11
		x11-libs/libXrandr
	)
	ladspa? ( media-libs/ladspa-sdk )
	lv2? (
		media-libs/freetype
		media-libs/lv2
		x11-libs/cairo[X]
		x11-libs/libX11
		x11-libs/libXrandr
	)
	vst? (
		media-libs/freetype
		x11-libs/cairo[X]
		x11-libs/libX11
		x11-libs/libXrandr
	)
"
RDEPEND="${DEPEND}"

lsp_emake() {
	local myemakeargs=(
		FEATURES="${MODULES[*]}"
		PREFIX="/usr"
		LIBDIR="/usr/$(get_libdir)"

		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		LD="$(tc-getLD)"

		CFLAGS_EXT="${CFLAGS}"
		CXXFLAGS_EXT="${CXXFLAGS}"
		LDFLAGS_EXT="$(raw-ldflags)"
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
		$(usev doc 'doc')
		$(usev jack 'jack')
		$(usev ladspa 'ladspa')
		$(usev lv2 'lv2')
		$(usev test 'test')
		$(usev vst 'vst2')
		$(usev X 'xdg')
	)

	lsp_emake config
}

src_compile() {
	lsp_emake
}

src_test() {
	# TODO: wire up tests (https://github.com/lsp-plugins/lsp-plugins#testing)
	:;
}

src_install() {
	lsp_emake DESTDIR="${ED}" install
}
