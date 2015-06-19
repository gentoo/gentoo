# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/sgt-puzzles/sgt-puzzles-9861.ebuild,v 1.3 2015/04/26 16:00:09 pacho Exp $

EAPI=5
inherit eutils gnome2-utils toolchain-funcs games
if [[ ${PV} == "99999999" ]] ; then
	ESVN_REPO_URI="svn://svn.tartarus.org/sgt/puzzles"
	inherit subversion
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-r${PV}.tar.gz"
	S=${WORKDIR}/puzzles-r${PV}
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Simon Tatham's Portable Puzzle Collection"
HOMEPAGE="http://www.chiark.greenend.org.uk/~sgtatham/puzzles/"

LICENSE="MIT"
SLOT="0"
IUSE="doc"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig
	doc? ( >=app-doc/halibut-1.0 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	./mkfiles.pl
	sed -i \
		-e 's:= -O2 -Wall -Werror -ansi -pedantic -g:= $(CPPFLAGS):' \
		-e '/LDFLAGS/s:=:=$(LDFLAGS) :' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
	if use doc ; then
		halibut --text --html --info --pdf --ps puzzles.but
	fi
}

src_install() {
	dodir "${GAMES_BINDIR}"
	emake DESTDIR="${D}" gamesdir="${GAMES_BINDIR}" install
	dodoc README HACKING

	local file name
	for file in *.R ; do
		[[ ${file} == "nullgame.R" ]] && continue
		name=$(awk -F: '/exe:/ { print $3 }' "${file}")
		file=${file%.R}
		if [[ ${PV} -lt 99999999 ]] ; then
			newicon -s 48 icons/${file}-48d24.png ${PN}-${file}.png
			make_desktop_entry "${GAMES_BINDIR}/${file}" "${name}" "${PN}-${file}"
		else
			# No icons with the live version
			make_desktop_entry "${GAMES_BINDIR}/${file}" "${name}"
		fi
	done

	dodoc puzzles.txt puzzles.chm
	if use doc ; then
		dohtml *.html
		doinfo puzzles.info
		dodoc puzzles.pdf puzzles.ps
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	[[ ${PV} -lt 99999999 ]] && gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	[[ ${PV} -lt 99999999 ]] && gnome2_icon_cache_update
}

pkg_postrm() {
	[[ ${PV} -lt 99999999 ]] && gnome2_icon_cache_update
}
