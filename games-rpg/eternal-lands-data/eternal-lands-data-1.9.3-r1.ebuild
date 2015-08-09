# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit games

MUSIC_DATE="20060803"

MY_PV="${PV//_/}"
MY_PV="${MY_PV//./}"
MY_PN="${PN%*-data}"
DESCRIPTION="An online MMORPG written in C and SDL"
HOMEPAGE="http://www.eternal-lands.com"
SRC_URI="http://www.eternal-lands.com/el_linux_193.zip
		music? ( mirror://gentoo/el_music_full-${MUSIC_DATE}.zip )
		sound? ( http://www.eternallands.co.uk/EL_sound_191.zip )"
# WARNING: The music file is held at
# http://www.eternal-lands.com/page/music.php
# We only mirror it so that it is versioned by the date we mirrored it
# AND prefixed with el_ so as not cause any conflicts. Maybe oneday they will
# version their music, maybe not.

LICENSE="eternal_lands"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="music sound bloodsuckermaps"

DEPEND="app-arch/unzip
		!bloodsuckermaps? ( !games-rpg/eternal-lands-bloodsucker )"

PDEPEND="bloodsuckermaps? ( >=games-rpg/eternal-lands-bloodsucker-3.0_p20110618 )"

# Maybe one day upstream will do things in a consistent way.
S="${WORKDIR}/el_linux"

src_prepare() {
	# Move our music files to the correct directory
	if use music ; then
		mkdir music
		mv ../*.ogg ../*.pll music || die
	fi

	# Fix assertion error with >=libxml2-2.9 (see bug #449352)
	xmllint --noent actor_defs/actor_defs.xml > actor_defs.xml || die "Failed parsing actor_defs.xml"
	mv actor_defs.xml actor_defs
}

src_install() {
	# These are provided by eternal-lands ebuild

	rm license.txt
	rm commands.lst

	# don't install maps if using alternate maps
	if use bloodsuckermaps ; then
		rm maps/anitora.dds maps/cave1.dds maps/cont2map10.dds
		rm maps/cont2map11.dds maps/cont2map12.dds maps/cont2map13.dds
		rm maps/cont2map14.dds maps/cont2map15.dds maps/cont2map16.dds
		rm maps/cont2map17.dds maps/cont2map18.dds maps/cont2map19.dds
		rm maps/cont2map1.dds maps/cont2map20.dds maps/cont2map21.dds
		rm maps/cont2map22.dds maps/cont2map23.dds maps/cont2map24.dds
		rm maps/cont2map2.dds maps/cont2map3.dds maps/cont2map4.dds
		rm maps/cont2map5.dds maps/cont2map6.dds maps/cont2map7.dds
		rm maps/cont2map8.dds maps/cont2map9.dds maps/irilion.dds
		rm maps/legend.dds maps/map11.dds maps/map12.dds
		rm maps/map13.dds maps/map14f.dds maps/map15f.dds
		rm maps/map2.dds maps/map3.dds maps/map4f.dds
		rm maps/map5nf.dds maps/map6nf.dds maps/map7.dds
		rm maps/map8.dds maps/map9f.dds maps/seridia.dds
		rm maps/startmap.dds
	fi

	insopts -m 0660
	insinto "${GAMES_DATADIR}/${MY_PN}"
	doins -r 2dobjects 3dobjects actor_defs animations maps meshes \
		particles skeletons shaders textures languages shaders skybox \
		*.lst 3dobjects.txt *.xml \
		|| die "doins failed"

	if use music ; then
		doins -r music || die "doins music failed"
	fi

	# Removed sound from above - need to handle sound support

	cd "${WORKDIR}"
	if use sound ; then
	   doins -r sound || die "doins sound failed"
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	# Ensure that the files are writable by the game group for auto
	# updating.
	chmod -R g+rw "${ROOT}/${GAMES_DATADIR}/${MY_PN}"

	# Make sure new files stay in games group
	find "${ROOT}/${GAMES_DATADIR}/${MY_PN}" -type d -exec chmod g+sx {} \;
}
