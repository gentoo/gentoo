# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="The ultimate old-school single player dungeon exploration game"
HOMEPAGE="https://www.nethack.org/"
SRC_URI="https://nethack.org/download/${PV}/nethack-${PV//.}-src.tgz -> ${P}.tar.gz"

LICENSE="nethack"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="X"

RDEPEND="
	acct-group/gamestat
	sys-libs/ncurses:0=
	X? (
		x11-libs/libXaw
		x11-libs/libXpm
		x11-libs/libXt
	)
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	virtual/pkgconfig
	virtual/yacc
	X? (
		x11-apps/bdftopcf
		x11-apps/mkfontscale
	)
"

S="${WORKDIR}/NetHack-NetHack-${PV}_Released"

src_prepare() {
	eapply "${FILESDIR}/${PN}-3.6.3-recover.patch"
	eapply_user

	cp "${FILESDIR}/${PN}-3.6.3-hint-$(usex X x11 tty)" hint || die "Failed to copy hint file"
	sys/unix/setup.sh hint || die "Failed to run setup.sh"
}

src_compile() {
	append-cflags -I../include -DDLB -DSECURE -DTIMED_DELAY -DVISION_TABLES -DDUMPLOG -DSCORE_ON_BOTL
	append-cflags '-DCOMPRESS=\"${EPREFIX}/bin/gzip\"' '-DCOMPRESS_EXTENSION=\".gz\"'
	append-cflags "-DHACKDIR=\\\"${EPREFIX}/usr/$(get_libdir)/nethack\\\"" "-DVAR_PLAYGROUND=\\\"${EPREFIX}/var/games/nethack\\\""
	append-cflags "-DDEF_PAGER=\\\"${PAGER}\\\""
	append-cflags -DSYSCF "-DSYSCF_FILE=\\\"${EPREFIX}/etc/nethack.sysconf\\\""

	use X && append-cflags -DX11_GRAPHICS -DUSE_XPM

	LOCAL_MAKEOPTS=(
		CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LFLAGS="${LDFLAGS}"
		WINTTYLIB="$($(tc-getPKG_CONFIG) --libs ncurses)"
		HACKDIR="${EPREFIX}/usr/$(get_libdir)/nethack" INSTDIR="${ED}/usr/$(get_libdir)/nethack"
		SHELLDIR="${ED}/usr/bin" VARDIR="${ED}/var/games/nethack"
		)

	emake "${LOCAL_MAKEOPTS[@]}" nethack recover Guidebook spec_levs

	# Upstream still has some parallel compilation bugs
	emake -j1 "${LOCAL_MAKEOPTS[@]}" all
}

src_install() {
	emake "${LOCAL_MAKEOPTS[@]}" install

	mv "${ED}/usr/$(get_libdir)/nethack/recover" "${ED}/usr/bin/recover-nethack" || die "Failed to move recover-nethack"

	doman doc/nethack.6
	newman doc/recover.6 recover-nethack.6
	dodoc doc/Guidebook.txt

	insinto /etc
	newins sys/unix/sysconf nethack.sysconf

	insinto /etc/skel
	newins "${FILESDIR}/${PN}-3.6.0-nethackrc" .nethackrc

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

	elog "A minimal default .nethackrc has been placed in /etc/skel/"
	elog "The sysconf file is at /etc/nethack.sysconf"
}
