# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Dodge the rocks for as long as possible until you die"
HOMEPAGE="https://bitbucket.org/rpkrawczyk/rockdodger"
SRC_URI="https://bitbucket.org/rpkrawczyk/rockdodger/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	media-libs/libsdl[joystick,sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod,wav]"
DEPEND="${DEPEND}"

src_compile() {
	tc-export CC

	local emakeargs=(
		prefix="${EPREFIX}"/usr
		gamesdir="${EPREFIX}"/var/games/${PN}
		MOREOPTS="${CFLAGS} ${CPPFLAGS}"
	)
	emake "${emakeargs[@]}"
}

src_install() {
	dobin ${PN}
	doman ${PN}.6

	insinto /usr/share/${PN}
	doins -r data/.

	newicon ${PN}.icon.64x64.xpm ${PN}.xpm
	domenu ${PN}.desktop

	dodir /var/games/${PN}
	touch "${ED}"/var/games/${PN}/${PN}.scores || die

	fowners -R :gamestat /{usr/bin,var/games}/${PN}
	fperms 660 /var/games/${PN}/${PN}.scores
	fperms g+s /usr/bin/${PN}
}
