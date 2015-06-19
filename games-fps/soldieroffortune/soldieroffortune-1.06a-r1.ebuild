# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/soldieroffortune/soldieroffortune-1.06a-r1.ebuild,v 1.6 2015/06/14 19:55:37 ulm Exp $

EAPI=5
inherit check-reqs eutils unpacker cdrom games

DESCRIPTION="First-person shooter based on the mercenary trade"
HOMEPAGE="http://www.lokigames.com/products/sof/"
SRC_URI="mirror://lokigames/sof/sof-${PV}-cdrom-x86.run"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="strip"
IUSE=""

DEPEND="games-util/loki_patch"
RDEPEND="sys-libs/glibc
	amd64? ( sys-libs/glibc[multilib] )
	virtual/opengl[abi_x86_32(-)]
	media-libs/libsdl[X,opengl,sound,abi_x86_32(-)]
	x11-libs/libXrender[abi_x86_32(-)]
	x11-libs/libXrandr[abi_x86_32(-)]
	media-libs/smpeg[abi_x86_32(-)]"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${ED}/${dir}
unpackDir=${T}/unpack

CHECKREQS_DISK_BUILD="1450M"
CHECKREQS_DISK_USR="725M"

pkg_pretend() {
	check-reqs_pkg_pretend
}

src_unpack() {
	cdrom_get_cds sof.xpm
	unpack_makeself
	mkdir ${unpackDir} || die
	tar xzf "${CDROM_ROOT}"/paks.tar.gz -C "${unpackDir}" || die
	tar xzf "${CDROM_ROOT}"/binaries.tar.gz -C "${unpackDir}" || die
}

src_install() {
	einfo "Copying files... this may take a while..."
	exeinto "${dir}"
	doexe "${CDROM_ROOT}"/bin/x86/glibc-2.1/sof
	insinto "${dir}"
	doins -r "${unpackDir}"/*
	doins "${CDROM_ROOT}"/{README,kver.pub,sof.xpm}

	cd "${S}"
	export _POSIX2_VERSION=199209
	loki_patch --verify patch.dat
	loki_patch patch.dat "${Ddir}" >& /dev/null || die

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find "${Ddir}" -exec touch '{}' +

	games_make_wrapper sof ./sof "${dir}" "${dir}"

	# fix buffer overflow
	sed -i -e '/^exec/i \
export MESA_EXTENSION_MAX_YEAR=2003 \
export __GL_ExtensionStringVersion=17700' \
		"${ED}/${GAMES_BINDIR}/sof" || die

	doicon "${CDROM_ROOT}"/sof.xpm
	make_desktop_entry sof "Soldier of Fortune" sof

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "To play the game run:"
	elog " sof"
}
