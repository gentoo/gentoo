# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils toolchain-funcs flag-o-matic user

MY_PV=${PV//.}
DESCRIPTION="The ultimate old-school single player dungeon exploration game"
HOMEPAGE="http://www.nethack.org/"
SRC_URI="mirror://sourceforge/nethack/${PN}-${MY_PV}-src.tgz"

LICENSE="nethack"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="experimental X"

RDEPEND="sys-libs/ncurses:0=
	X? (
		x11-libs/libXaw
		x11-libs/libXpm
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? (
		x11-proto/xproto
		x11-apps/bdftopcf
		x11-apps/mkfontdir
	)"

BINDIR="/usr/bin"
STATEDIR="/var/games/${PN}"

NETHACK_GROUP="gamestat"

pkg_setup() {
	HACKDIR="/usr/$(get_libdir)/${PN}"

	enewgroup gamestat 36
}

src_prepare() {
	eapply "${FILESDIR}/${P}-recover.patch"
	eapply_user

	cp "${FILESDIR}/${P}-hint-$(usex X x11 tty)" hint || die "Failed to copy hint file"
	sys/unix/setup.sh hint || die "Failed to run setup.sh"
}

src_compile() {
	append-cflags -I../include -DDLB -DSECURE -DLINUX -DTIMED_DELAY -DVISION_TABLES
	append-cflags '-DCOMPRESS=\"/bin/gzip\"' '-DCOMPRESS_EXTENSION=\".gz\"'
	append-cflags "-DHACKDIR=\\\"${HACKDIR}\\\"" "-DVAR_PLAYGROUND=\\\"${STATEDIR}\\\""
	append-cflags "-DDEF_PAGER=\\\"${PAGER}\\\""
	append-cflags -DSYSCF "-DSYSCF_FILE=\\\"/etc/nethack.sysconf\\\""

	use X && append-cflags -DX11_GRAPHICS -DUSE_XPM
	use experimental &&
		append-cflags -DSTATUS_VIA_WINDOWPORT -DSTATUS_HILITES -DSCORE_ON_BOTL

	makeopts=(
		CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LFLAGS="${LDFLAGS}"
		WINTTYLIB="$($(tc-getPKG_CONFIG) --libs ncurses)"
		HACKDIR="${HACKDIR}" INSTDIR="${D}/${HACKDIR}"
		SHELLDIR="${D}/${BINDIR}" VARDIR="${D}/${STATEDIR}"
		)

	emake "${makeopts[@]}" nethack recover Guidebook spec_levs

	# Upstream still has some parallel compilation bugs
	emake -j1 "${makeopts[@]}" all
}

src_install() {
	emake "${makeopts[@]}" install

	exeinto "${BINDIR}"
	newexe util/recover recover-nethack
	rm "${D}/${HACKDIR}/recover" || die "Failed to remove HACKDIR/recover"

	doman doc/nethack.6
	newman doc/recover.6 recover-nethack.6
	dodoc doc/Guidebook.txt

	insinto /etc
	newins sys/unix/sysconf nethack.sysconf

	insinto /etc/skel
	newins "${FILESDIR}/${P}-nethackrc" .nethackrc

	if use X ; then
		cd "${S}/win/X11" || die "Failed to enter win/X11 directory"

		# copy nethack x application defaults
		insinto /etc/X11/app-defaults
		newins NetHack.ad NetHack
		rm "${D}/${HACKDIR}/NetHack.ad" || die "Failed to remove NetHack.ad"

		newicon nh_icon.xpm nethack.xpm
		make_desktop_entry ${PN} Nethack

		# install nethack fonts
		bdftopcf -o nh10.pcf nh10.bdf || die "Converting fonts failed"
		bdftopcf -o ibm.pcf ibm.bdf || die "Converting fonts failed"
		insinto "${HACKDIR}/fonts"
		doins *.pcf
		cd "${D}/${HACKDIR}/fonts" || die "Failed to enter fonts directory"
		mkfontdir || die "The action mkfontdir ${HACKDIR}/fonts failed"
	fi

	rm -r "${D}/${STATEDIR}" || die "Failed to clean STATEDIR"
	keepdir "${STATEDIR}/save"

	fowners -R "root:${NETHACK_GROUP}" "${STATEDIR}"
	fperms 770 "${STATEDIR}" "${STATEDIR}/save"

	fowners "root:${NETHACK_GROUP}" "${HACKDIR}/nethack"
	fperms g+s "${HACKDIR}/nethack"
}

pkg_postinst() {
	cd "${ROOT}/${STATEDIR}" || die "Failed to enter ${STATEDIR} directory"

	touch logfile perm record xlogfile || die "Failed to create log files"

	chown -R root:"${NETHACK_GROUP}" . &&
	chmod -R 660 . &&
	chmod 770 . save ||
	die "Adjustment of file permissions in ${ROOT}/${STATEDIR} failed"

	touch -c bones* save/*  # non-critical

	elog "A minimal default .nethackrc has been placed in /etc/skel/"
	elog "The sysconf file is at /etc/nethack.sysconf"

	if has_version "<${CATEGORY}/${PN}-3.6.0" ; then
		elog
		elog "Nethack 3.6 includes many new features."
		elog "You might want to review your options and local patchset."
		elog "Have a look at http://www.nethack.org/v360/release.html"
	fi
}
