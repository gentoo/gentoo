# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop unpacker

DESCRIPTION="Sci-fi action RPG in a stunning futuristic city"
HOMEPAGE="https://www.gog.com/game/transistor"
SRC_URI="transistor_${PV//./_}.sh"
RESTRICT="bindist fetch mirror strip test"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="dev-lang/mono
	media-libs/libsdl2[opengl,video]"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	elog "Please buy and download ${SRC_URI} from"
	elog "https://www.gog.com/game/transistor"
}

src_unpack() {
	unpack_zip "${DISTDIR}/${A}"
}

src_prepare() {
	default
	rm -r support/{xdg*,*.{sh,txt}} || die
	rm game/lib{,64}/libSDL2* || die

	if ! use x86; then
		rm game/Transistor.bin.x86 || die
		rm -r game/lib || die
	fi
	if ! use amd64; then
		rm game/Transistor.bin.x86_64 || die
		rm -r game/lib64 || die
	fi
}

src_install() {
	insinto /opt/gog/transistor
	doins -r .
	fperms 755 /opt/gog/transistor/start.sh

	if use x86; then
		fperms 755 /opt/gog/transistor/game/Transistor.bin.x86
	fi
	if use amd64; then
		fperms 755 /opt/gog/transistor/game/Transistor.bin.x86_64
	fi

	make_desktop_entry "/opt/gog/transistor/start.sh" "Transistor" transistor
	newicon support/icon.png transistor.png
}
