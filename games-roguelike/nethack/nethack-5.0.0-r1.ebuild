# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-4 )

inherit desktop flag-o-matic lua-single toolchain-funcs

DESCRIPTION="The ultimate old-school single player dungeon exploration game"
HOMEPAGE="https://www.nethack.org/"
SRC_URI="https://nethack.org/download/${PV}/nethack-${PV//.}-src.tgz -> ${P}.tar.gz"
S="${WORKDIR}/NetHack-${PV}"

LICENSE="nethack"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE="X qt6"
REQUIRED_USE="
	${LUA_REQUIRED_USE}
"

RDEPEND="
	${LUA_DEPS}
	acct-group/gamestat
	sys-apps/util-linux
	sys-libs/ncurses:0=
	X? (
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXpm
		x11-libs/libXt
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		dev-qt/qtmultimedia:6
	)
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	virtual/pkgconfig
	app-alternatives/lex
	app-alternatives/yacc
	X? (
		x11-apps/bdftopcf
		x11-apps/mkfontscale
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.0-system-lua.patch"
	"${FILESDIR}/${PN}-5.0.0-recover.patch"
	"${FILESDIR}/${PN}-3.6.6-clang16.patch"
	"${FILESDIR}/${PN}-5.0.0-no-define-warn-unused-result.patch"
	"${FILESDIR}/${PN}-3.6.7-path-max.patch"
	"${FILESDIR}/${PN}-5.0.0-hurd-tparm.patch"
	"${FILESDIR}/${PN}-5.0.0-fix_make.patch"
	"${FILESDIR}/${PN}-5.0.0-help.patch"

	# see https://bugs.gentoo.org/975067, backport
	"${FILESDIR}/${P}-fix_musl_gcc.patch"
)

pkg_setup() {
	lua-single_pkg_setup
}

src_prepare() {
	default

	pushd sys/unix >/dev/null || die
	sed -i \
		-e "s:pkg-config:$(tc-getPKG_CONFIG):g" \
		-e 's:-DCOMPRESS=[^ ]*::' \
		-e 's:-DSYSCF_FILE=[^ ]*::' \
		-e '/^GIT_.* :=/d' \
		hints/linux.${PV//./} || die

	# the absence of lua_get_CFLAGS will warn if the sed does nothing
	sed -i \
		-e 's:^CCFLAGS = -g:CCFLAGS = $(MYCFLAGS):' \
		-e 's:^CCXXFLAGS = -g:CCXXFLAGS = $(MYCXXFLAGS):' \
		hints/include/compiler.${PV//./} || die

	sed -i \
		-e "s/^GDBPATH=/#GDBPATH=/" \
		sysconf || die

	# use precompiled Guidebook.txt, lots of troff errors on Hurd
	sed -i \
		-e '/^ALLDEP = .*/s/Guidebook//' \
		Makefile.top || die

	./setup.sh hints/linux.${PV//./} || die "Failed to run setup.sh"
	popd >/dev/null || die
}

src_compile() {
	# custom options
	append-cppflags -DVISION_TABLES -DSCORE_ON_BOTL

	# fix paths
	append-cppflags '-DCOMPRESS=\"${EPREFIX}/bin/gzip\"'
	append-cppflags '-DDEF_PAGER=\"${PAGER}\"'
	append-cppflags '-DSYSCF_FILE=\"${EPREFIX}/etc/nethack.sysconf\"'
	append-cppflags '-DVAR_PLAYGROUND=\"${EPREFIX}/var/games/nethack\"'

	# -Wlto-type-mismatch, bug #973698
	use qt6 && filter-lto

	LOCAL_MAKEOPTS=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		MYCFLAGS="${CFLAGS} ${CPPFLAGS} $(lua_get_CFLAGS)"
		LFLAGS="${LDFLAGS}"

		# musl
		$(usev elibc_musl musl=1)
		UUID_LIB_CHECK="1" # checked with ldconfig -p

		# use system lua
		SYSTEM_LUA=1
		LUA_VERSION="$(lua_get_version)"
		LUA_HEADER_DIR="${ESYSROOT}/$(lua_get_include_dir)"
		LUA_LIBS="$(lua_get_LIBS)"

		# custom path
		HACKDIR="${EPREFIX}/usr/$(get_libdir)/nethack"

		# graphic backends
		WANT_WIN_ALL=
		WANT_WIN_TTY=1
		WANT_WIN_CURSES=1
		WANT_WIN_X11=$(usev X)
		WANT_WIN_QT=$(usev qt6)
		WANT_WIN_QT6=$(usev qt6)
	)

	if use qt6; then
		LOCAL_MAKEOPTS+=(
			MYCXXFLAGS="${CXXFLAGS} ${CPPFLAGS} $(lua_get_CFLAGS)"
			QTDIR="${ESYSROOT}/usr"
		)
	fi

	# already in MYC{,XX)FLAGS, unset to allow CFLAGS ?= with useful flags then
	unset CFLAGS CXXFLAGS

	# Upstream still has some parallel compilation bugs.
	emake -j1 "${LOCAL_MAKEOPTS[@]}" all
}

# do nothing but warnings
src_test() { :; }

src_install() {
	LOCAL_MAKEOPTS+=(
		GAMEPERM=02755
		CHOWN=true
		CHGRP=true

		POSTINSTALL=
		INSTDIR="${ED}/usr/$(get_libdir)/nethack"
		SHELLDIR="${ED}/usr/bin"
		VARDIR="${ED}/var/games/nethack"
	)

	emake -j1 "${LOCAL_MAKEOPTS[@]}" install

	mv "${ED}/usr/$(get_libdir)/nethack/recover" "${ED}/usr/bin/recover-nethack" || die "Failed to move recover-nethack"

	doman doc/nethack.6
	newman doc/recover.6 recover-nethack.6
	dodoc doc/Guidebook.txt

	insinto /etc
	newins sys/unix/sysconf nethack.sysconf

	if use X; then
		mkdir -p "${ED}/etc/X11/app-defaults/" || die "Failed to make app-defaults directory"
		mv "${ED}/usr/$(get_libdir)/nethack/NetHack.ad" "${ED}/etc/X11/app-defaults/" || die "Failed to move NetHack.ad"

		make_desktop_entry --eapi9 ${PN} -n Nethack

		pushd "${S}"/win/X11 >/dev/null || die
		newicon nh_icon.xpm nethack.xpm

		# install nethack fonts
		bdftopcf -o nh10.pcf nh10.bdf || die "Converting fonts failed"
		bdftopcf -o ibm.pcf ibm.bdf || die "Converting fonts failed"
		local fontdir="/usr/$(get_libdir)/nethack/fonts"
		insinto "${fontdir}"
		doins *.pcf
		mkfontdir "${ED}/${fontdir}" || die "mkfontdir failed"
		popd >/dev/null || die
	fi

	rm -r "${ED}/var/games/nethack" || die "Failed to clean var/games/nethack"
	keepdir /var/games/nethack/save
}

pkg_preinst() {
	fowners root:gamestat /var/games/nethack /var/games/nethack/save
	fperms 2770 /var/games/nethack /var/games/nethack/save

	fowners root:gamestat "/usr/$(get_libdir)/nethack/nethack"
	fperms g+s "/usr/$(get_libdir)/nethack/nethack"
}

pkg_postinst() {
	pushd "${EROOT}/var/games/nethack" >/dev/null || die "Failed to enter ${EROOT}/var/games/nethack directory"

	# Transition mechanism for <nethack-3.6.1 ebuilds. It's perfectly safe, so we'll just run it unconditionally.
	chmod 2770 . save || die "Failed to chmod statedir"

	# Those files can't be created earlier because we don't want portage to wipe them during upgrades
	( umask 007 && touch logfile perm record xlogfile ) || die "Failed to create log files"

	# Instead of using a proper version header in its save files, nethack checks for incompatibilities
	# by comparing the mtimes of save files and its own binary. This would require admin interaction even
	# during upgrades which don't change the file format, so we'll just touch the files and warn the admin
	# manually in case of compatibility issues.
	(
		shopt -s nullglob
		local saves=( bones* save/* )
		[[ -n "${saves[*]}" ]] && touch -c "${saves[@]}"
	) # non-fatal
	popd >/dev/null || die
}
