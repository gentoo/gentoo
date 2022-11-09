# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="collection of games from NetBSD"
HOMEPAGE="https://www.polyomino.org.uk/computer/software/bsd-games/"
SRC_URI="https://github.com/msharov/bsd-games/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-3.1-verbose-build.patch.gz"

LICENSE="BSD"
# Subslot indicates the fork / new version
# 3 doesn't include the same games as the classic variant, etc
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~mips ~riscv ~x86"

# 'check' target doesn't exist, nor do any actual tests
# bug #779649
RESTRICT="test"

DEPEND="
	sys-apps/miscfiles
	sys-libs/ncurses:=[unicode(+)]
	!games-puzzle/hangman
	!games-misc/wumpus
"
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

PATCHES=(
	"${WORKDIR}"/${PN}-3.1-verbose-build.patch
	"${FILESDIR}"/${PN}-3.1-no-install-manpages-automatically.patch
	"${FILESDIR}"/${PN}-3.2-no-which.patch
	"${FILESDIR}"/${P}-no-strip.patch
)

# Set GAMES_TO_BUILD variable to whatever you want
GAMES_TO_BUILD=${GAMES_TO_BUILD:=adventure atc battlestar caesar cribbage
dab drop4 gofish gomoku hangman klondike robots sail snake spirhunt
worm wump}

src_prepare() {
	default

	# Use completely our own CFLAGS/LDFLAGS, no stripping and so on
	sed -i \
		-e 's/+= -std=c11 @pkgcflags@ ${CFLAGS}/= -std=c11 @pkgcflags@ ${CPPFLAGS} ${CFLAGS} ${LDFLAGS}/' \
		-e 's/+= @pkgldflags@ ${LDFLAGS}/= @pkgldflags@ ${LDFLAGS}/' \
		-e s'/${INSTALL} -m 755 -s/${INSTALL} -m 755/' \
		-e '/man[6]dir/d' \
		Config.mk.in || die

	# Yes, this stinks.
	# Right now, the custom configure script calls pkg-config manually
	# and seds it a bunch, and this is easier.
	# Force looking for both ncurses and ncursesw
	sed -i -e 's/pkgs="ncurses"/pkgs="ncursesw"/' configure || die

	cp "${FILESDIR}"/config.params-gentoo config.params || die
	echo bsd_games_cfg_usrlibdir=\"$(get_libdir)\" >> ./config.params || die
	echo bsd_games_cfg_build_dirs=\"${GAMES_TO_BUILD}\" >> ./config.params || die
	echo bsd_games_cfg_docdir=\"/usr/share/doc/${PF}\" >> ./config.params || die
	if use riscv; then
		sed -i 's/${CC} ${ldflags} -o $@ $^/${CC} ${ldflags} -o $@ $^ -latomic/' ./*/Module.mk || die
	fi
}

src_configure() {
	tc-export AR CC RANLIB

	econf
}

src_compile() {
	emake CPPFLAGS="${CPPFLAGS}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodir /var/games
	emake DESTDIR="${D}" install

	_build_game() {
		has ${1} ${GAMES_TO_BUILD}
	}

	_do_statefile() {
		touch "${ED}"/var/games/${1} || die
		chmod ug+rw "${ED}"/var/games/${1} || die
	}

	# set some binaries to run as games group (+S)
	_build_game atc && fperms g+s /usr/bin/atc
	_build_game battlestar && fperms g+s /usr/bin/battlestar
	_build_game canfield && fperms g+s /usr/bin/canfield
	_build_game cribbage && fperms g+s /usr/bin/cribbage
	_build_game phantasia && fperms g+s /usr/bin/phantasia
	_build_game robots && fperms g+s /usr/bin/robots
	_build_game sail && fperms g+s /usr/bin/sail
	_build_game snake && fperms g+s /usr/bin/snake
	_build_game tetris && fperms g+s /usr/bin/tetris-bsd

	# state files
	_build_game atc && _do_statefile atc_score
	_build_game battlestar && _do_statefile battlestar.log
	_build_game canfield && _do_statefile cfscores
	_build_game cribbage && _do_statefile criblog
	_build_game hack && keepdir /var/games/hack
	_build_game robots && _do_statefile robots_roll
	_build_game sail && _do_statefile saillog
	_build_game snake && _do_statefile snake.log && _do_statefile snakerawscores
	_build_game tetris && _do_statefile tetris-bsd.scores

	# extra docs
	_build_game atc && docinto atc
	_build_game boggle && { docinto boggle ; dodoc boggle/README; }
	_build_game hack && { docinto hack ; dodoc hack/{OWNER,Original_READ_ME,READ_ME,help}; }
	_build_game hunt && { docinto hunt ; dodoc hunt/README; }
	_build_game phantasia && { docinto phantasia ; dodoc phantasia/{OWNER,README}; }

	# Install the man pages manually to make life easier (circumventing compression)
	local game
	for game in ${GAMES_TO_BUILD[@]} ; do
		if [[ -e ${game}/${game}.1 ]] ; then
			doman ${game}/${game}.1
		else
			doman ${game}/${game}.6
		fi
	done

	# Since factor is usually not installed, and primes.6 is a symlink to
	# factor.6, make sure that primes.6 is ok ...
	if _build_game primes && [[ ! $(_build_game factor) ]] ; then
		rm -f "${ED}"/usr/share/man/man6/{factor,primes}.6 || die
		newman factor/factor.6 primes.6
	fi

	# All of this needs to be owned by the gamestat group
	fowners -R :gamestat /var/games/
	# ... and so do the binaries
	fowners -R :gamestat /usr/bin/

	# State dirs
	fperms -R ug+rw /var/games/
}
