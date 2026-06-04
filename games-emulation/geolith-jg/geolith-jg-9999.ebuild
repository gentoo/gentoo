# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN=${PN%-*}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Jolly Good Neo Geo AES/MVS/CD/CDZ Emulator"
HOMEPAGE="https://gitlab.com/jgemu/geolith"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/jgemu/${MY_PN}.git"
else
	SRC_URI="https://gitlab.com/jgemu/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD MIT MIT-0"
SLOT="1"
IUSE="chdr"

DEPEND="
	dev-libs/miniz:=
	media-libs/jg:1=
	media-libs/speexdsp
	chdr? ( media-libs/libchdr:= )
"
RDEPEND="
	${DEPEND}
	games-emulation/jgrf
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local makeopts=(
		PREFIX="${EPREFIX}"/usr
		ENABLE_CHDR=$(usex chdr 1 0)
		USE_EXTERNAL_MINIZ=1
	)
	export MY_MAKEOPTS="${makeopts[@]}"
}

src_compile() {
	local mymakeargs=(
		CC="$(tc-getCC)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		${MY_MAKEOPTS}
	)
	emake "${mymakeargs[@]}"
}

src_install() {
	local mymakeargs=(
		DESTDIR="${D}"
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF}
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		${MY_MAKEOPTS}
	)
	emake install "${mymakeargs[@]}"
}
