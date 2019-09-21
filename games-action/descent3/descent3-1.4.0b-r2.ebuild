# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils unpacker cdrom multilib games

IUSE="nocd videos"
DESCRIPTION="Descent 3 - 3-Dimensional indoor/outdoor spaceship combat"
HOMEPAGE="http://www.lokigames.com/products/descent3/"
SRC_URI="mirror://lokigames/${PN}/${PN}-1.4.0a-x86.run
	mirror://lokigames/${PN}/${P}-x86.run"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip mirror bindist"

RDEPEND="sys-libs/glibc
	media-libs/libsdl[abi_x86_32(-)]
	media-libs/smpeg[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]"

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

pkg_setup() {
	games_pkg_setup
	if use videos ; then
		ewarn "The installed game takes about 1.2GB of space!"
	elif use nocd ; then
		ewarn "The installed game takes about 510MB of space!"
	else
		ewarn "The installed game takes about 220MB of space!"
	fi
}

src_unpack() {
	if use videos ; then
		cdrom_get_cds missions/d3.mn3 movies/level1.mve
	else
		cdrom_get_cds missions/d3.mn3
	fi
	mkdir -p "${S}"/{a,b} || die
	cd "${S}"/a || die
	unpack_makeself ${PN}-1.4.0a-x86.run
	cd "${S}"/b || die
	unpack_makeself ${P}-x86.run
}

src_install() {
	einfo "Copying files... this may take a while..."
	exeinto "${dir}"
	doexe ${CDROM_ROOT}/bin/x86/glibc-2.1/{${PN},nettest}
	insinto "${dir}"
	doins ${CDROM_ROOT}/{FAQ.txt,README{,.mercenary},d3.hog,icon.{bmp,xpm}}

	cd "${Ddir}" || die
	# TODO: move this to src_unpack where it belongs
	tar xzf ${CDROM_ROOT}/data.tar.gz || die
	tar xzf ${CDROM_ROOT}/shared.tar.gz || die

	if use nocd; then
		doins -r ${CDROM_ROOT}/missions
	fi

	if use videos ; then
		cdrom_load_next_cd
		doins -r ${CDROM_ROOT}/movies
	fi

	cd "${S}"/a || die
	bin/Linux/x86/loki_patch --verify patch.dat || die
	bin/Linux/x86/loki_patch patch.dat "${Ddir}" >& /dev/null || die
	cd "${S}"/b || die
	bin/Linux/x86/loki_patch --verify patch.dat || die
	bin/Linux/x86/loki_patch patch.dat "${Ddir}" >& /dev/null || die

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find "${Ddir}" -exec touch '{}' +

	games_make_wrapper descent3 ./descent3.dynamic "${dir}" "${dir}"
	newicon ${CDROM_ROOT}/icon.xpm ${PN}.xpm

	# Fix for 2.6 kernel crash
	cd "${Ddir}" || die
	ln -sf ppics.hog PPics.Hog

	prepgamesdirs
	make_desktop_entry ${PN} "Descent 3" ${PN}
}

pkg_postinst() {
	games_pkg_postinst
	elog "To play the game run:"
	elog " descent3"
	echo
}
