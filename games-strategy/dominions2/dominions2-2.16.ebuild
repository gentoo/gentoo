# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/dominions2/dominions2-2.16.ebuild,v 1.13 2015/06/01 20:49:09 mr_bones_ Exp $

EAPI=5
inherit eutils cdrom games

DESCRIPTION="Dominions 2: The Ascension Wars is an epic turn-based fantasy strategy game"
HOMEPAGE="http://www.illwinter.com/dom2/index.html"
SRC_URI="x86? (
		http://www.shrapnelgames.com/downloads/dompatch${PV/\./}_linux_x86.tgz )
	amd64? (
		http://www.shrapnelgames.com/downloads/dompatch${PV/\./}_linux_x86.tgz )
	ppc? (
		http://www.shrapnelgames.com/downloads/dompatch${PV/\./}_linux_ppc.tgz )
	doc? ( http://www.shrapnelgames.com/downloads/DOM2_Walkthrough.pdf
		http://www.shrapnelgames.com/downloads/manual_addenda.pdf )
	mirror://gentoo/${PN}.png"

# I am not sure what license applies to Dominions II and I couldn't find
# further information on their homepage or on the game CD :(
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"
RESTRICT="bindist strip"

RDEPEND="
	|| (
		ppc? (
			media-libs/libsdl
			virtual/opengl
			virtual/glu
		)
		!ppc? (
			media-libs/libsdl[abi_x86_32(-)]
			virtual/opengl[abi_x86_32(-)]
			virtual/glu[abi_x86_32(-)]
		)
	)"

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	mkdir -p "${S}"/patch || die
	cd "${S}"/patch || die
	if use x86 || use amd64 ; then
		unpack dompatch${PV/\./}_linux_x86.tgz
	elif use ppc ; then
		unpack dompatch${PV/\./}_linux_ppc.tgz
	fi
}

src_install() {
	cdrom_get_cds dom2icon.ico
	einfo "Copying files to harddisk... this may take a while..."

	exeinto "${dir}"
	if use amd64 || use x86 ; then
		doexe "${CDROM_ROOT}"/bin_lin/x86/dom2*
	elif use ppc ; then
		doexe "${CDROM_ROOT}"/bin_lin/ppc/dom2*
	fi
	insinto "${dir}"
	doins -r "${CDROM_ROOT}"/dominions2.app/Contents/Resources/*
	dodoc "${CDROM_ROOT}"/doc/*

	# applying the official patches just means overwriting some important
	# files with their more recent versions:
	einfo "Applying patch for version ${PV}..."
	dodoc "${S}"/patch/doc/*
	doexe "${S}"/patch/dom2
	rm -rf "${S}"/patch/doc/ "${S}"/patch/dom2 || die
	doins -r "${S}"/patch/*

	if use doc; then
		elog ""
		elog "Installing extra documentation to '/usr/share/doc/${P}'"
		elog ""
		elog "You may want to study 'DOM2_Walkthrough.pdf' carefully if"
		elog "you are new to Dominions II."
		elog ""
		dodoc "${DISTDIR}"/{DOM2_Walkthrough,manual_addenda}.pdf
	fi

	doicon "${DISTDIR}"/${PN}.png

	# update times
	find "${D}" -exec touch '{}' \;

	games_make_wrapper dominions2 ./dom2 "${dir}" "${dir}"
	make_desktop_entry dominions2 "Dominions II" dominions2

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "To play the game run:"
	elog " dominions2"
	echo
}
