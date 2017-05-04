# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cdrom estack eutils xdg

DESCRIPTION="The Curse of Monkey Island, the third game in the series"
HOMEPAGE="https://en.wikipedia.org/wiki/The_Curse_of_Monkey_Island"
LICENSE="${PN}"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="bindist"

RDEPEND=">=games-engines/scummvm-0.4.0"

S="${WORKDIR}"

dotar() {
	cd "${CDROM_ABSMATCH%/*}" || die
	eshopts_push -s nocaseglob nullglob

	# Lowercase
	# Documentation into doc
	# Remainder into data
	# Avoid copying files twice

	tar c \
		--mode=u+w \
		--ignore-case \
		--xform='s:^[^a-z]+$:\L\0:x' \
		--xform='s:.*:data/\0:x' \
		--xform='s:.*\.(pdf|txt)$:doc/\0:x' \
		--xform='s:^doc/data/:doc/:x' \
		--exclude="$(use doc || echo '*.pdf')" \
		--exclude-from=<(find "${WORKDIR}"/data -type f -printf "%P\n" 2>/dev/null) \
		*.{txt,pdf} *.la[0-9] resource*/ \
		| tar x -C "${WORKDIR}"

	assert "tar failed"
	eshopts_pop

	# Don't prevent CD ejection.
	cd "${WORKDIR}" || die
}

src_unpack() {
	cdrom_get_cds comi.la1 comi.la2
	dotar

	cdrom_load_next_cd
	dotar
}

src_install() {
	insinto /usr/share/games/scummvm/games/comi
	doins -r data/*

	# Documentation may be missing.
	[[ -d doc ]] && dodoc doc/*

	doicon "${FILESDIR}"/${PN}.jpg
	make_wrapper ${PN} "scummvm comi"
	make_desktop_entry ${PN} "The Curse of Monkey Island" ${PN}.jpg
}
