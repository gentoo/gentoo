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
	qt6? ( dev-qt/qtbase:6 )
"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.0-system-lua.patch"
	"${FILESDIR}/${PN}-5.0.0-recover.patch"
	"${FILESDIR}/${PN}-3.6.6-clang16.patch"
	"${FILESDIR}/${PN}-5.0.0-no-define-warn-unused-result.patch"
	"${FILESDIR}/${PN}-3.6.7-path-max.patch"
	"${FILESDIR}/${PN}-5.0.0-hurd-tparm.patch"
)

pkg_setup() {
	lua-single_pkg_setup
}

src_prepare() {
	default

	local hint="${FILESDIR}/${PN}-3.6.3-hint-tty"
	use X && hint="${FILESDIR}/${PN}-5.0.0-hint-x11"
	use qt6 && hint="${FILESDIR}/${PN}-5.0.0-hint-qt6"
	use X && use qt6 && hint="${FILESDIR}/${PN}-5.0.0-hint-qt6-x11"

	cp "${hint}" hint || die "Failed to copy hint file"
	sys/unix/setup.sh hint || die "Failed to run setup.sh"
}

src_compile() {
	local qt_cflags qt_libs

	append-cflags -std=gnu99 # NetHack 5.0 contains C99 code, but still incompatible with c2x
	append-cflags -I../include -DDLB -DSECURE -DTIMED_DELAY -DVISION_TABLES -DDUMPLOG -DSCORE_ON_BOTL
	append-cflags '-DCOMPRESS=\"${EPREFIX}/bin/gzip\"' '-DCOMPRESS_EXTENSION=\".gz\"'
	append-cflags "-DHACKDIR=\\\"${EPREFIX}/usr/$(get_libdir)/nethack\\\""
	append-cflags "-DVAR_PLAYGROUND=\\\"${EPREFIX}/var/games/nethack\\\""
	append-cflags "-DDEF_PAGER=\\\"${PAGER}\\\""
	append-cflags -DSYSCF "-DSYSCF_FILE=\\\"${EPREFIX}/etc/nethack.sysconf\\\""
	append-cflags "$(lua_get_CFLAGS)"

	if use X; then
		append-cflags -DX11_GRAPHICS -DUSE_XPM

		# XtErrorHandler usage seems right, but headers "may" add ((noreturn))
		# giving an incompatible type error with clang-16 (could alternatively
		# use private _X_NORETURN but this may be fragile)
		append-cflags -Wno-error=incompatible-pointer-types #874462
	fi

	use qt6 && append-cflags -DQT_GRAPHICS -DUSE_XPM -DSND_LIB_QTSOUND -DUSER_SOUNDS

	if use qt6; then
		qt_cflags="$($(tc-getPKG_CONFIG) --cflags Qt6Gui Qt6Widgets Qt6Multimedia)"
		qt_libs="$($(tc-getPKG_CONFIG) --libs Qt6Gui Qt6Widgets Qt6Multimedia)"
		append-cxxflags -std=gnu++20 -I. -I../include $(lua_get_CFLAGS)
		append-cxxflags -DQT_GRAPHICS -DUSE_XPM -DSND_LIB_QTSOUND -DUSER_SOUNDS ${qt_cflags} -fPIC
		append-cxxflags "-DHACKDIR=\\\"${EPREFIX}/usr/$(get_libdir)/nethack\\\""
		use X && append-cxxflags -DX11_GRAPHICS
	fi

	LOCAL_MAKEOPTS=(
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" CFLAGS="${CFLAGS}" LFLAGS="${LDFLAGS}"
		SYSTEM_LUA=1
		LUA_VERSION="$(lua_get_version)"
		LUA_HEADER_DIR="$(lua_get_include_dir)"
		LUA_LIBS="$(lua_get_LIBS)"
		WINTTYLIB="$($(tc-getPKG_CONFIG) --libs ncurses)"
		HACKDIR="${EPREFIX}/usr/$(get_libdir)/nethack"
	)

	if use qt6; then
		LOCAL_MAKEOPTS+=(
			CXXFLAGS="${CXXFLAGS}"
			QTLIBS="${qt_libs}"
			MOCPATH="$($(tc-getPKG_CONFIG) Qt6Gui --variable=libexecdir)/moc"
			QTDIR="${EPREFIX}/usr"
		)
	fi

	# Upstream still has some parallel compilation bugs.
	emake -j1 "${LOCAL_MAKEOPTS[@]}" nethack recover spec_levs
	# XXX: Lots of troff errors on Hurd, so don't build the Guidebook there for now.
	! use kernel_Hurd && emake -j1 "${LOCAL_MAKEOPTS[@]}" Guidebook

	emake -j1 "${LOCAL_MAKEOPTS[@]}" all
}

src_install() {
	emake \
		"${LOCAL_MAKEOPTS[@]}" \
		INSTDIR="${ED}/usr/$(get_libdir)/nethack" \
		SHELLDIR="${ED}/usr/bin" \
		VARDIR="${ED}/var/games/nethack" \
		install

	mv "${ED}/usr/$(get_libdir)/nethack/recover" "${ED}/usr/bin/recover-nethack" || die "Failed to move recover-nethack"

	doman doc/nethack.6
	newman doc/recover.6 recover-nethack.6
	dodoc doc/Guidebook.txt

	insinto /etc
	newins sys/unix/sysconf nethack.sysconf

	if use X ; then
		cd "${S}/win/X11" || die "Failed to enter win/X11 directory"

		mkdir -p "${ED}/etc/X11/app-defaults/" || die "Failed to make app-defaults directory"
		mv "${ED}/usr/$(get_libdir)/nethack/NetHack.ad" "${ED}/etc/X11/app-defaults/" || die "Failed to move NetHack.ad"

		newicon nh_icon.xpm nethack.xpm
		make_desktop_entry ${PN} Nethack

		# install nethack fonts
		bdftopcf -o nh10.pcf nh10.bdf || die "Converting fonts failed"
		bdftopcf -o ibm.pcf ibm.bdf || die "Converting fonts failed"
		insinto "/usr/$(get_libdir)/nethack/fonts"
		doins *.pcf
		mkfontdir "${ED}/usr/$(get_libdir)/nethack/fonts" || die "mkfontdir failed"
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
	cd "${EROOT}/var/games/nethack" || die "Failed to enter ${EROOT}/var/games/nethack directory"

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
}
