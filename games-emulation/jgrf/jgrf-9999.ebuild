# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs xdg

DESCRIPTION="The Jolly Good Reference Frontend"
HOMEPAGE="https://jgemu.gitlab.io/jgrf.html"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/jgemu/${PN}.git"
else
	SRC_URI="https://gitlab.com/jgemu/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="BSD CC0-1.0 MIT ZLIB"
SLOT="1"
IUSE="vulkan"

DEPEND="
	dev-libs/miniz
	dev-libs/openssl:0=
	>=media-libs/jg-2.0.0
	media-libs/libepoxy[egl(+)]
	media-libs/libsdl3[opengl,udev]
	media-libs/speexdsp
	vulkan? (
		dev-util/vulkan-headers
		media-libs/libsdl3[vulkan]
		media-libs/vulkan-loader
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	vulkan? ( dev-util/glslang )
"

src_configure() {
	local makeopts=(
		PREFIX="${EPREFIX}"/usr
		USE_EXTERNAL_MD5=1
		USE_EXTERNAL_MINIZ=1
		ENABLE_VULKAN=$(usex vulkan 1 0)
	)
	export MY_MAKEOPTS="${makeopts[@]}"
}

src_compile() {
	local mymakeargs=(
		CC="$(tc-getCC)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		${MY_MAKEOPTS}
	)
	emake "${mymakeargs[@]}"
}

src_install() {
	local mymakeargs=(
		DESTDIR="${D}" \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF}
		${MY_MAKEOPTS}
	)
	emake install "${mymakeargs[@]}"
}
