# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DEB_PATCH_VER=28
DESCRIPTION="Collection of games from NetBSD"
HOMEPAGE="https://www.polyomino.org.uk/computer/software/bsd-games/"
#SRC_URI="https://www.polyomino.org.uk/computer/software/bsd-games/${PN}-$(ver_cut 1-2).tar.gz"
SRC_URI="http://deb.debian.org/debian/pool/main/b/bsdgames/bsdgames_$(ver_cut 1-2).orig.tar.gz"
SRC_URI+=" mirror://debian/pool/main/b/bsdgames/bsdgames_$(ver_cut 1-2)-${DEB_PATCH_VER}.debian.tar.xz"
S="${WORKDIR}/${PN}-$(ver_cut 1-2)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"

DEPEND="
	sys-apps/miscfiles
	sys-libs/ncurses:0=
	!app-misc/banner
	!games-misc/wtf
	!games-puzzle/hangman
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

# Set GAMES_TO_BUILD variable to whatever you want
GAMES_TO_BUILD=${GAMES_TO_BUILD:=adventure arithmetic atc
backgammon banner battlestar bcd boggle caesar canfield countmail cribbage
dab dm fish gomoku hack hangman hunt mille monop morse
number phantasia pig pom primes ppt quiz rain random robots sail snake
tetris trek wargames worm worms wtf}

src_prepare() {
	local debian_patch_dir="${WORKDIR}"/debian/patches
	for patch in $(<"${debian_patch_dir}"/series) ; do
		eapply "${debian_patch_dir}"/${patch}
	done

	# Additional patches on top of Debian patchset
	eapply "${FILESDIR}"/${PN}-2.17-64bitutmp.patch
	eapply "${FILESDIR}"/${PN}-2.17-bg.patch
	eapply "${FILESDIR}"/${PN}-2.17-gcc4.patch
	eapply "${FILESDIR}"/${PN}-2.17-rename-getdate-clash.patch

	default

	# Use pkg-config to query Libs: from ncurses.pc (for eg. -ltinfo) wrt #459652
	sed -i \
		-e "/ncurses_lib/s:-lncurses:'$($(tc-getPKG_CONFIG) --libs-only-l ncurses)':" \
		configure || die

	sed -i \
		-e "s:/usr/games:/usr/bin:" \
		wargames/wargames || die

	sed -i \
		-e '/^CC :=/d' \
		-e '/^CXX :=/d' \
		-e '/^CFLAGS/s/OPTIMIZE/CFLAGS/' \
		-e '/^CXXFLAGS/s/OPTIMIZE/CXXFLAGS/' \
		-e '/^LDFLAGS/s/LDFLAGS := /LDFLAGS := \$(LDFLAGS) /' \
		Makeconfig.in || die

	# Used by config.params
	export GAMES_BINDIR=/usr/bin
	export GAMES_DATADIR=/usr/share
	export GAMES_STATEDIR=/var/games
	cp "${FILESDIR}"/config.params-gentoo config.params || die

	echo bsd_games_cfg_usrlibdir=\"$(get_libdir)\" >> ./config.params || die
	echo bsd_games_cfg_build_dirs=\"${GAMES_TO_BUILD}\" >> ./config.params || die
	echo bsd_games_cfg_docdir=\"/usr/share/doc/${PF}\" >> ./config.params || die
}

src_compile() {
	tc-export CC CXX

	emake
}

src_test() {
	addwrite /dev/full
	emake -j1 check
}

src_install() {
	# TODO: ${PN} or no?
	dodir /var/games /usr/share/man/man{1,6}
	emake -j1 DESTDIR="${D}" install

	dodoc AUTHORS BUGS ChangeLog ChangeLog.0 \
		README PACKAGING SECURITY THANKS TODO YEAR2000

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

	elog "Renaming monop to monop-bsd to avoid collision with dev-lang/mono"
	mv "${ED}"/usr/bin/monop "${ED}"/usr/bin/monop-bsd || die

	# state files
	_build_game atc && _do_statefile atc_score
	_build_game battlestar && _do_statefile battlestar.log
	_build_game canfield && _do_statefile cfscores
	_build_game cribbage && _do_statefile criblog
	_build_game hack && keepdir /var/games/hack
	_build_game robots && _do_statefile robots_roll
	_build_game sail && _do_statefile sail/saillog
	_build_game snake && _do_statefile snake.log && _do_statefile snakerawscores
	_build_game tetris && _do_statefile tetris-bsd.scores

	# extra docs
	_build_game atc && { docinto atc ; dodoc atc/BUGS; }
	_build_game boggle && { docinto boggle ; dodoc boggle/README; }
	_build_game hack && { docinto hack ; dodoc hack/{OWNER,Original_READ_ME,READ_ME,help}; }
	_build_game hunt && { docinto hunt ; dodoc hunt/README; }
	_build_game phantasia && { docinto phantasia ; dodoc phantasia/{OWNER,README}; }

	# All of this needs to be owned by the gamestat group
	fowners -R :gamestat /var/games/
	# ... and so do the binaries
	fowners -R :gamestat /usr/bin/

	# State dirs
	chmod -R ug+rw "${ED}"/var/games/ || die
}
