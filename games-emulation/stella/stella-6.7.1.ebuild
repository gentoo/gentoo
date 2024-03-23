# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs xdg

DESCRIPTION="Multi-platform Atari 2600 VCS Emulator"
HOMEPAGE="https://stella-emu.github.io/"
SRC_URI="https://github.com/stella-emu/stella/releases/download/${PV}/${P}-src.tar.xz"

LICENSE="GPL-2+ BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+joystick png zlib"
REQUIRED_USE="png? ( zlib )"

RDEPEND="
	dev-db/sqlite:3
	media-libs/libsdl2[joystick?,opengl,sound,video]
	png? ( media-libs/libpng:= )
	zlib? ( sys-libs/zlib:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i 's/pkg-config/${PKG_CONFIG}/' configure || die
	sed -i '/CXXFLAGS+=/s/-fomit-frame-pointer//' Makefile || die
}

src_configure() {
	tc-export CC CXX PKG_CONFIG

	# not autotools-based
	local configure=(
		./configure
		--host=${CHOST}
		--prefix="${EPREFIX}"/usr
		--docdir="${EPREFIX}"/usr/share/doc/${PF}/html
		$(use_enable joystick)
		$(use_enable png)
		$(use_enable zlib zip)
		${EXTRA_ECONF}
	)

	echo ${configure[*]}
	"${configure[@]}" || die
}

src_install() {
	local DOCS=(
		Announce.txt Changes.txt README-SDL.txt
		Readme.txt docs/R77_readme.txt Todo.txt
	)

	default

	rm -- "${ED}"/usr/share/doc/${PF}/html/*.txt || die
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ ${REPLACING_VERSIONS} ]] && ver_test ${REPLACING_VERSIONS} -lt 6.7; then
		elog "With version >=6.7, because of fixes to JSON handling, all remappings"
		elog "will be reset to defaults. If you had custom mappings, they will need"
		elog "to be re-entered again."
		elog
		elog "Furthermore, because of internal changes, all old state files are invalid."
	fi
}
