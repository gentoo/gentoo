# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic xdg

DESCRIPTION="Linux Studio Plugins"
HOMEPAGE="https://lsp-plug.in"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sadko4u/lsp-plugins"
	EGIT_BRANCH="devel"
else
	SRC_URI="https://github.com/sadko4u/${PN}/releases/download/${PV}/${PN}-src-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="LGPL-3"
SLOT="0"
IUSE="doc jack ladspa +lv2 test vst X"
REQUIRED_USE="|| ( jack ladspa lv2 )
	test? ( jack )"

RESTRICT="!test? ( test )"

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

src_configure() {
	use doc && MODULES+="doc"
	use jack && MODULES+=" jack"
	use ladspa && MODULES+=" ladspa"
	use lv2 && MODULES+=" lv2"
	use vst && MODULES+=" vst2"
	use X && MODULES+=" xdg"
	emake \
		FEATURES="${MODULES}" \
		PREFIX="/usr" \
		LIBDIR="/usr/$(get_libdir)" \
		CFLAGS_EXT="${CFLAGS}" \
		CXXFLAGS_EXT="${CXXFLAGS}" \
		LDFLAGS_EXT="$(raw-ldflags)" \
		VERBOSE=1 \
		config
}

src_compile() {
	emake \
		FEATURES="${MODULES}" \
		PREFIX="/usr" \
		LIBDIR="/usr/$(get_libdir)" \
		CFLAGS_EXT="${CFLAGS}" \
		CXXFLAGS_EXT="${CXXFLAGS}" \
		LDFLAGS_EXT="$(raw-ldflags)" \
		VERBOSE=1
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${ED}" LIB_PATH="/usr/$(get_libdir)" VERBOSE=1 install
}
