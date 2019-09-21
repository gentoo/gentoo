# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop autotools

DESCRIPTION="Atari 800 emulator"
HOMEPAGE="https://atari800.github.io/"
SRC_URI="https://sourceforge.net/projects/${PN}/files/${PN}/${PV}/${P}.tar.gz
	https://sourceforge.net/projects/${PN}/files/ROM/Original%20XL%20ROM/xf25.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ncurses oss opengl readline +sdl +sound"

NOTSDL_DEPS="
	sys-libs/ncurses:0=
	sound? (
		!oss? ( media-libs/libsdl[sound] )
	)
"
RDEPEND="
	sdl? ( >=media-libs/libsdl-1.2.0[opengl?,sound?,video] )
	ncurses? ( ${NOTSDL_DEPS} )
	!sdl? ( !ncurses? ( ${NOTSDL_DEPS} ) )
	readline? (
		sys-libs/readline:0=
		sys-libs/ncurses:0= )
	media-libs/libpng:0=
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

src_prepare() {
	default

	# remove some not-so-interesting ones
	rm -f DOC/{INSTALL.*,*.in,CHANGES.OLD} || die
	sed -i \
		-e '1s/ 1 / 6 /' \
		src/atari800.man || die
	sed "s:/usr/share/games:/usr/share:" \
		"${FILESDIR}"/atari800.cfg > "${T}"/atari800.cfg || die

	# Bug 544608
	eapply "${FILESDIR}/${P}-tgetent-detection.patch"
	pushd src > /dev/null && eautoreconf
	popd > /dev/null
}

src_configure() {
	local video="ncurses"
	local sound=no

	use sdl && video="sdl"
	if use sound ; then
		if use sdl ; then
			sound=sdl
		elif use oss ; then
			sound=oss
		else
			echo
			elog "Sound requested but neither sdl nor oss specified."
			elog "Disabling sound suport."
		fi
	fi

	cd src && \
		econf \
			$(use_with readline) \
			--with-video=${video} \
			--with-sound=${sound}
}

src_compile() {
	emake -C src
}

src_install () {
	dobin src/atari800
	newman src/atari800.man atari800.6
	dodoc README.1ST DOC/*
	insinto "/usr/share/${PN}"
	doins "${WORKDIR}/"*.ROM
	insinto /etc
	doins "${T}"/atari800.cfg
	newicon data/atari2.svg ${PN}.svg
	make_desktop_entry ${PN} "Atari 800 emulator"
}
