# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN=${PN%-*}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Jolly Good Port of melonDS"
HOMEPAGE="https://gitlab.com/jgemu/melonds"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/jgemu/${MY_PN}.git"
else
	SRC_URI="https://gitlab.com/jgemu/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-1 BSD-2 GPL-3+ MIT Unlicense public-domain"
SLOT="1"

DEPEND="
	media-libs/jg:1=
	media-libs/libsamplerate
"
RDEPEND="
	${DEPEND}
	games-emulation/jgrf
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-format.patch
)

src_compile() {
	emake -C jollygood \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake -C jollygood install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}
