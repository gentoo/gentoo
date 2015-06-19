# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/nwn-cep/nwn-cep-1.68-r1.ebuild,v 1.5 2014/04/19 07:32:58 ulm Exp $

EAPI=2
inherit games unpacker

DESCRIPTION="The Community Expansion Pack for Neverwinter Nights"
HOMEPAGE="http://nwn.bioware.com/players/cep.html"
SRC_URI="http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/hakpaks/6057/cepv152_man.rar
	http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/hakpaks/6974/CEP168.rar"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="mirror bindist"

DEPEND=""
RDEPEND=">=games-rpg/nwn-1.68"

pkg_setup() {
	games_pkg_setup
	if ! has_version 'games-rpg/nwn-data[hou,sou]' ; then
		eerror "${P} requires NWN v1.68, Shadows of Undrentide, and Hordes of"
		eerror "the Underdark. Please make sure you have all three before using"
		eerror "this patch."
		die "Requirements not met"
	fi
}

src_install() {
	dodir "${GAMES_PREFIX_OPT}"/nwn/{hak,tlk,texturepacks,modules,cep}

	# Using mv below instead of doins due to large file sizes
	mv *.hak HotU/*.hak "${D}/${GAMES_PREFIX_OPT}"/nwn/hak/ || die "Installing hak files failed"
	mv *.tlk "${D}/${GAMES_PREFIX_OPT}"/nwn/tlk/ || die "Installing tlk files failed"
	mv *.erf "${D}/${GAMES_PREFIX_OPT}"/nwn/texturepacks/ || die "Installing erf files failed"
	mv *.mod "${D}/${GAMES_PREFIX_OPT}"/nwn/modules/ || die "Installing mod files failed"
	mv *.pdf *.txt "${D}/${GAMES_PREFIX_OPT}"/nwn/cep/ || die "Installing documentation failed"
	prepgamesdirs
}
