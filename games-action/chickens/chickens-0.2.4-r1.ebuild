# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

MY_P="ChickensForLinux-Linux-${PV}"

DESCRIPTION="Target chickens with rockets and shotguns. Funny"
HOMEPAGE="http://www.chickensforlinux.com/"
SRC_URI="http://www.chickensforlinux.com/${MY_P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist mirror"

RDEPEND="
	acct-group/gamestat
	media-libs/allegro:0[X]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-bitmap.patch
	"${FILESDIR}"/${P}-settings.patch
)

src_prepare() {
	default

	# sed kept for historical reasons
	sed -i 's|....\(.\)\(_\)\(.*.4x0\)\(.\)|M\4\2\x42\x6Fn\1s\2|' HighScores || die

	sed -i "s|HighScores|${EPREFIX}/var/games/${PN}.hs|" highscore.cpp || die

	sed -e "s|options.cfg|${EPREFIX}/etc/${PN}/&|" \
		-e "s|sound/|${EPREFIX}/usr/share/${PN}/&|" \
		-e "s|dat/|${EPREFIX}/usr/share/${PN}/&|" \
		-i main.cpp README || die
}

src_configure() {
	: # this configure file does no good
}

src_compile() {
	local obj=([!m]*.cpp)
	tc-export CXX
	append-cppflags $($(tc-getPKG_CONFIG) --cflags allegro || die)
	append-libs $($(tc-getPKG_CONFIG) --libs allegro || die)
	emake -E "main: ${obj[*]/.cpp/.o}" LDLIBS="${LIBS}"
}

src_install() {
	newbin main ${PN}
	dodoc AUTHOR README

	insinto /usr/share/${PN}
	doins -r dat sound

	insinto /etc/${PN}
	doins options.cfg

	insinto /var/games
	newins HighScores ${PN}.hs

	fowners :gamestat /usr/bin/${PN} /var/games/${PN}.hs
	fperms g+s /usr/bin/${PN}
	fperms 660  /var/games/${PN}.hs

	make_desktop_entry ${PN} ${PN^} applications-games
}
