# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils autotools user

DESCRIPTION="An arcade 2D shoot-em-up game"
HOMEPAGE="http://linux.tlk.fr/"
SRC_URI="http://linux.tlk.fr/games/Powermanga/download/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=media-libs/libsdl-1.2[sound,joystick,video]
	media-libs/libpng:0
	media-libs/sdl-mixer[mod]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXxf86dga"
DEPEND=${RDEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
)

pkg_setup(){
	enewgroup gamestat 36
}

src_prepare() {
	default

	local f
	for f in src/assembler.S src/assembler_opt.S ; do
		einfo "patching $f"
		cat <<-EOF >> ${f}
		#if defined(__linux__) && defined(__ELF__)
		.section .note.GNU-stack,"",%progbits
		#endif
		EOF
	done
	eautoreconf
}

src_install() {
	newbin src/powermanga powermanga.bin
	doman powermanga.6
	dodoc AUTHORS CHANGES README

	insinto "/usr/share/${PN}"
	doins -r data sounds graphics texts

	find "${D}/usr/share/${PN}" -name "Makefil*" -execdir rm -f \{\} +

	dodir "/var/games/${PN}"
	fowners root:gamestat /var/games/${PN} /usr/bin/${PN}.bin
	fperms 660 /var/games/${PN}
	fperms 2755 /usr/bin/${PN}.bin

	local f
	for f in powermanga.hi-easy powermanga.hi powermanga.hi-hard ; do
		touch "${D}/var/games/${f}" || die
		fperms 660 "/var/games/${f}"
	done

	make_wrapper powermanga powermanga.bin "/usr/share/${PN}"
	make_desktop_entry powermanga Powermanga
}

pkg_postinst() {
	ewarn "NOTE: The highscore file format has changed."
	ewarn "Older highscores will not be retained."
}
