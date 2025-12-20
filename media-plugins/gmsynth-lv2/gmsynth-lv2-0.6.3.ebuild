# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="General MIDI Sample Player Plugin"
HOMEPAGE="https://x42-plugins.com/x42/x42-gmsynth"
SRC_URI="https://github.com/x42/gmsynth.lv2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/-lv2/.lv2}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2"

DEPEND="
	dev-libs/glib:2
	>=media-libs/lv2-1.18.6
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.3-makefile.patch
)

src_compile() {
	tc-export PKG_CONFIG CC
	MYEMAKEARGS=(
		gmsynth_VERSION="${PV}"
		HAVE_SSE="$(usex cpu_flags_x86_sse2)"
		# not standard but aligned with the path used by ardour
		# https://lv2plug.in/pages/filesystem-hierarchy-standard.html
		LV2DIR="${EPREFIX}/usr/$(get_libdir)/lv2"
		PREFIX="${EPREFIX}/usr"
		STRIP="true"
	)
	emake "${MYEMAKEARGS[@]}"
}

src_install() {
	emake "${MYEMAKEARGS[@]}" DESTDIR="${D}" install
}
