# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs flag-o-matic user

MY_PV=${PV//.}
DESCRIPTION="The ultimate old-school single player dungeon exploration game"
HOMEPAGE="http://www.nethack.org/"
SRC_URI="mirror://sourceforge/nethack/${PN}-${MY_PV}-src.tgz"

LICENSE="nethack"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="X"

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

BINDIR="/usr/games/bin"
STATEDIR="/var/games/${PN}"

NETHACK_GROUP="gamestat"

pkg_setup() {
	HACKDIR="/usr/$(get_libdir)/${PN}"

	enewgroup gamestat 36
}

src_prepare() {
	# This copies the /sys/unix Makefile.*s to their correct places for
	# seding and compiling.
	cd "sys/unix" || die "Could not go into sys/unix directory"
	source setup.sh || die

	cd ../.. || die "Failed to get back to main directory"
	epatch \
		"${FILESDIR}"/${PV}-gentoo-paths.patch \
		"${FILESDIR}"/${PV}-default-options.patch \
		"${FILESDIR}"/${PV}-bison.patch \
		"${FILESDIR}"/${PV}-macos.patch \
		"${FILESDIR}"/${P}-gibc210.patch \
		"${FILESDIR}"/${P}-recover.patch

	epatch_user

	mv doc/recover.6 doc/nethack-recover.6 || die "Could not rename recover.6 to nethack-recover.6"

	sed -i \
		-e "s:GENTOO_STATEDIR:${STATEDIR}:" include/unixconf.h \
		|| die "setting statedir"
	sed -i \
		-e "s:GENTOO_HACKDIR:${HACKDIR}:" include/config.h \
		|| die "setting hackdir"
	# set the default pager from the environment bug #52122
	if [[ -n "${PAGER}" ]] ; then
		sed -i \
			-e "115c\#define DEF_PAGER \"${PAGER}\"" \
			include/unixconf.h \
			|| die "setting statedir"
		# bug #57410
		sed -i \
			-e "s/^DATNODLB =/DATNODLB = \$(DATHELP)/" Makefile \
			|| die "sed Makefile failed"
	fi

	# sys-libs/ncurses[tinfo]
	sed -i \
		-e '/^WINTTYLIB/s| = .*| = '"$(
				$(tc-getPKG_CONFIG) --libs ncurses
			)"'|g' \
		src/Makefile || die

	if use X ; then
		epatch "${FILESDIR}/${PV}-X-support.patch"
	fi
}

src_compile() {
	local lflags="${LDFLAGS}"

	cd "${S}"/src || die "Failed to enter src directory"
	append-flags -I../include

	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LFLAGS="${lflags}" \
		../util/makedefs
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LFLAGS="${lflags}"
	cd "${S}"/util || die "Failed to enter util directory"
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LFLAGS="${lflags}" \
		recover
}

src_install() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		GAMEPERM=02755 \
		GAMEUID="root" GAMEGRP="${NETHACK_GROUP}" \
		PREFIX="${D}/usr" \
		GAMEDIR="${D}/${HACKDIR}" \
		SHELLDIR="${D}/${BINDIR}" \
		install

	# We keep this stuff in STATEDIR instead so tidy up.
	rm -rf "${D}/${HACKDIR}/"{nethack,recover,save}

	exeinto "${BINDIR}"
	newexe src/nethack nethack-bin
	newexe util/recover recover-nethack

	# The final nethack is a sh script.  This fixes the hard-coded
	# HACKDIR directory so it doesn't point to ${D}/usr/share/nethackdir
	# and points HACK to BINDIR/nethack-bin (see above)
	sed -i \
		-e "s:^\(HACKDIR=\).*$:\1${HACKDIR}:;
			s:^\(HACK=\).*$:\1${BINDIR}/nethack-bin:" \
		"${D}/${BINDIR}/nethack" \
		|| die "sed /${BINDIR}/nethack failed"

	doman doc/*.6
	dodoc doc/*.txt

	insinto /etc/skel
	newins "${FILESDIR}/dot.nethackrc" .nethackrc

	local windowtypes="tty"
	use X && windowtypes="${windowtypes} x11"
	set -- ${windowtypes}
	sed -i \
		-e "s:GENTOO_WINDOWTYPES:${windowtypes}:" \
		-e "s:GENTOO_DEFWINDOWTYPE:$1:" \
		"${D}/etc/skel/.nethackrc" \
		|| die "sed /etc/skel/.nethackrc failed"

	if use X ; then
		# install nethack fonts
		cd "${S}/win/X11" || die "Failed to enter win/X11 directory"
		bdftopcf -o nh10.pcf nh10.bdf || die "Converting fonts failed"
		bdftopcf -o ibm.pcf ibm.bdf || die "Converting fonts failed"
		insinto "${HACKDIR}/fonts"
		doins *.pcf
		cd "${D}/${HACKDIR}/fonts" || die "Failed to enter fonts directory"
		mkfontdir || die "The action mkfontdir ${HACKDIR}/fonts failed"

		# copy nethack x application defaults
		cd "${S}/win/X11" || die "Failed to enter win/X11 directory again"
		insinto /etc/X11/app-defaults
		newins NetHack.ad NetHack
		sed -i \
			-e 's:^!\(NetHack.tile_file.*\):\1:' \
			"${D}/etc/X11/app-defaults/NetHack" \
			|| die "sed /etc/X11/app-defaults/NetHack failed"

		newicon nh_icon.xpm nethack.xpm
		make_desktop_entry ${PN} Nethack
	fi

	keepdir "${STATEDIR}/save"
	rm "${D}/${HACKDIR}/"{logfile,perm,record}

	fowners -R "root:${NETHACK_GROUP}" "${STATEDIR}"
	fperms -R 660 "${STATEDIR}"
	fperms 770 "${STATEDIR}" "${STATEDIR}/save"

	fowners "root:${NETHACK_GROUP}" ${BINDIR}/nethack-bin
	fperms g+s ${BINDIR}/nethack-bin
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-3.4.3-r3" ; then
		migration=true

		# preserve STATEDIR/{logfile,record}
		# (previous ebuild rev mistakenly removes it)
		for f in "${ROOT}/${STATEDIR}/"{logfile,record} ; do
			if [[ -e "$f" ]] ; then
				cp "$f" "$T" || die "Failed to preserve ${ROOT}/${STATEDIR} files"
			else
				touch "$T/$f" || die "Failed to preserve ${ROOT}/${STATEDIR} files"
			fi
		done
	fi
}

pkg_postinst() {
	cd "${ROOT}/${STATEDIR}" || die "Failed to enter ${STATEDIR} directory"

	if [[ -v migration ]] ; then
		cp "$T/"{logfile,record} . ||
		die "Failed to preserve ${ROOT}/${STATEDIR} files"

		chown -R root:"${NETHACK_GROUP}" . &&
		chmod -R 660 . &&
		chmod 770 . save ||
		die "Adjustment of file permissions in ${ROOT}/${STATEDIR} failed"
	fi

	# we don't want to overwrite existing files, as they contain user data
	local files="logfile perm record"

	touch $files &&
	chmod 660 $files &&
	chown root:"${NETHACK_GROUP}" $files ||
	die "Adjustment of file permissions in "${ROOT}/${STATEDIR}" failed"

	elog "You may want to look at /etc/skel/.nethackrc for interesting options"
}
