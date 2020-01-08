# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs games

DEB_PATCH_VER=22
DESCRIPTION="collection of games from NetBSD"
HOMEPAGE="https://www.polyomino.org.uk/computer/software/bsd-games/"
SRC_URI="https://www.polyomino.org.uk/computer/software/bsd-games/${P}.tar.gz
	mirror://debian/pool/main/b/bsdgames/bsdgames_${PV}-${DEB_PATCH_VER}.debian.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE=""

RDEPEND="!games-misc/wtf
	!app-misc/banner
	!games-puzzle/hangman
	sys-libs/ncurses:0
	sys-apps/miscfiles"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison
	virtual/pkgconfig"

# Set GAMES_TO_BUILD variable to whatever you want
GAMES_TO_BUILD=${GAMES_TO_BUILD:=adventure arithmetic atc
backgammon banner battlestar bcd boggle caesar canfield countmail cribbage
dab dm factor fish gomoku hack hangman hunt mille monop morse
number phantasia pig pom ppt primes quiz rain random robots sail snake
tetris trek wargames worm worms wtf}

src_prepare() {
	local d="${WORKDIR}"/debian/patches
	EPATCH_SOURCE="${d}" epatch $(<"${d}"/series)

	# Used by gentoo config.params. See bug 531200
	export GAMES_BINDIR GAMES_DATADIR GAMES_STATEDIR

	epatch \
		"${FILESDIR}"/${P}-64bitutmp.patch \
		"${FILESDIR}"/${P}-headers.patch \
		"${FILESDIR}"/${P}-bg.patch \
		"${FILESDIR}"/${P}-gcc4.patch

	# Use pkg-config to query Libs: from ncurses.pc (for eg. -ltinfo) wrt #459652
	sed -i \
		-e "/ncurses_lib/s:-lncurses:'$($(tc-getPKG_CONFIG) --libs-only-l ncurses)':" \
		configure || die

	sed -i \
		-e "s:/usr/games:${GAMES_BINDIR}:" \
		wargames/wargames || die

	sed -i \
		-e '/^CC :=/d' \
		-e '/^CXX :=/d' \
		-e '/^CFLAGS/s/OPTIMIZE/CFLAGS/' \
		-e '/^CXXFLAGS/s/OPTIMIZE/CXXFLAGS/' \
		-e '/^LDFLAGS/s/LDFLAGS := /LDFLAGS := \$(LDFLAGS) /' \
		Makeconfig.in || die

	cp "${FILESDIR}"/config.params-gentoo config.params || die
	echo bsd_games_cfg_usrlibdir=\"$(games_get_libdir)\" >> ./config.params || die
	echo bsd_games_cfg_build_dirs=\"${GAMES_TO_BUILD}\" >> ./config.params || die
	echo bsd_games_cfg_docdir=\"/usr/share/doc/${PF}\" >> ./config.params || die
}

src_test() {
	addwrite /dev/full
	emake -j1 check
}

build_game() {
	has ${1} ${GAMES_TO_BUILD}
}

do_statefile() {
	touch "${D}/${GAMES_STATEDIR}/${1}" || die
	chmod ug+rw "${D}/${GAMES_STATEDIR}/${1}" || die
}

src_install() {
	dodir "${GAMES_BINDIR}" "${GAMES_STATEDIR}" /usr/share/man/man{1,6}
	emake -j1 DESTDIR="${D}" install

	dodoc AUTHORS BUGS ChangeLog ChangeLog.0 \
		README PACKAGING SECURITY THANKS TODO YEAR2000

	# set some binaries to run as games group (+S)
	build_game atc && fperms g+s "${GAMES_BINDIR}"/atc
	build_game battlestar && fperms g+s "${GAMES_BINDIR}"/battlestar
	build_game canfield && fperms g+s "${GAMES_BINDIR}"/canfield
	build_game cribbage && fperms g+s "${GAMES_BINDIR}"/cribbage
	build_game phantasia && fperms g+s "${GAMES_BINDIR}"/phantasia
	build_game robots && fperms g+s "${GAMES_BINDIR}"/robots
	build_game sail && fperms g+s "${GAMES_BINDIR}"/sail
	build_game snake && fperms g+s "${GAMES_BINDIR}"/snake
	build_game tetris && fperms g+s "${GAMES_BINDIR}"/tetris-bsd

	# state files
	build_game atc && do_statefile atc_score
	build_game battlestar && do_statefile battlestar.log
	build_game canfield && do_statefile cfscores
	build_game cribbage && do_statefile criblog
	build_game hack && keepdir "${GAMES_STATEDIR}"/hack
	build_game robots && do_statefile robots_roll
	build_game sail && do_statefile saillog
	build_game snake && do_statefile snake.log && do_statefile snakerawscores
	build_game tetris && do_statefile tetris-bsd.scores

	# extra docs
	build_game atc && { docinto atc ; dodoc atc/BUGS; }
	build_game boggle && { docinto boggle ; dodoc boggle/README; }
	build_game hack && { docinto hack ; dodoc hack/{OWNER,Original_READ_ME,READ_ME,help}; }
	build_game hunt && { docinto hunt ; dodoc hunt/README; }
	build_game phantasia && { docinto phantasia ; dodoc phantasia/{OWNER,README}; }

	# Since factor is usually not installed, and primes.6 is a symlink to
	# factor.6, make sure that primes.6 is ok ...
	if build_game primes && [[ ! $(build_game factor) ]] ; then
		rm -f "${D}"/usr/share/man/man6/{factor,primes}.6
		newman factor/factor.6 primes.6
	fi

	prepgamesdirs

	# state dirs
	chmod -R ug+rw "${D}/${GAMES_STATEDIR}"/* || die
}
