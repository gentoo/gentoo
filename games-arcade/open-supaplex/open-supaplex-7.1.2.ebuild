# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="OSS reimplementation of Supaplex in C and SDL"
HOMEPAGE="https://github.com/sergiou87/open-supaplex"
SRC_URI="https://github.com/sergiou87/open-supaplex/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/libsdl2[joystick,sound,video]
	media-libs/sdl2-mixer[vorbis]
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( dev-lang/ruby )
"

src_prepare() {
	default
	rm -r resources/audio-{l,m}q || die
}

src_compile() {
	append-cflags -DFILE_FHS_XDG_DIRS -DFILE_DATA_PATH="${EPREFIX}/usr/share/OpenSupaplex"
	emake -C linux CC="$(tc-getCC)"
}

src_test() {
	emake -C tests CC="$(tc-getCC)"
	# Avoid installing savegames, configs, etc, if any were written during the test
	cp -R resources "${T}/test" || die
	cd tests || die
	OPENSUPAPLEX_PATH="${T}/test" ./run-tests.rb ./opensupaplex || die
}

src_install() {
	dobin linux/opensupaplex
	insinto /usr/share/OpenSupaplex
	doins -r resources/*
	doicon "${FILESDIR}/open-supaplex.svg"
	make_desktop_entry opensupaplex OpenSupaplex open-supaplex
}
