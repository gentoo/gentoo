# Copyright 2022-2023 Gentoo Authors
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
	KEYWORDS="~amd64"
fi

LICENSE="BSD CC0-1.0 MIT ZLIB"
SLOT="1"

DEPEND="
	dev-libs/miniz
	dev-libs/openssl:0=[-bindist(-)]
	media-libs/jg:1=
	media-libs/libepoxy[egl]
	media-libs/libsdl2[opengl,sound,video]
	media-libs/speexdsp
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		PREFIX="${EPREFIX}"/usr \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		USE_EXTERNAL_MD5=1 \
		USE_EXTERNAL_MINIZ=1
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		USE_EXTERNAL_MD5=1 \
		USE_EXTERNAL_MINIZ=1
}
