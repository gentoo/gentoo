# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils toolchain-funcs games autotools

if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="git://git.tartarus.org/simon/puzzles.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	MAGIC=c0bc13c
	SRC_URI="http://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-${PV}.${MAGIC}.tar.gz"
	S=${WORKDIR}/puzzles-${PV}.${MAGIC}
	KEYWORDS="amd64 x86"
fi

GENTOO_ICONS="20160315"
SRC_URI="${SRC_URI}
	https://dev.gentoo.org/~np-hardass/distfiles/${PN}/${PN}-icons-${GENTOO_ICONS}.tar.xz
"

DESCRIPTION="Simon Tatham's Portable Puzzle Collection"
HOMEPAGE="http://www.chiark.greenend.org.uk/~sgtatham/puzzles/"

LICENSE="MIT"
SLOT="0"
IUSE="doc gtk3 icons"

RDEPEND="
	!gtk3? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig
	doc? ( >=app-doc/halibut-1.0 )"

src_unpack() {
	[[ ${PV} == "99999999" ]] && git-r3_src_unpack
	unpack ${A}
}

src_prepare() {
	sed -i \
		-e 's/-O2 -Wall -Werror -ansi -pedantic -g//' \
		-e "s/libstr =/libstr = '\$(LDFLAGS) ' ./" \
		mkfiles.pl || die
	./mkfiles.pl || die
	eautoreconf

	# Import icons from latest Gentoo tarball
	if [[ ${PV} == "99999999" ]] || use icons; then
		cp -R ../${PN}-icons/icons . || die
	fi
}

src_configure() {
	econf --with-gtk=$(usex gtk3 3 2)
}

src_compile() {
	emake CC="$(tc-getCC)"
	if use doc ; then
		halibut --text --html --info --pdf --ps puzzles.but || die
	fi
}

src_install() {
	dodir "${GAMES_BINDIR}"
	emake DESTDIR="${D}" bindir="${GAMES_BINDIR}" install
	dodoc README

	local file name
	for file in *.R ; do
		[[ ${file} == "nullgame.R" ]] && continue
		name=$(awk -F: '/exe:/ { print $3 }' "${file}")
		file=${file%.R}
		newicon -s 48 icons/${file}-48d24.png ${PN}-${file}.png
		make_desktop_entry "${GAMES_BINDIR}/${file}" "${name}" "${PN}-${file}"
	done

	if use doc ; then
		dohtml *.html
		doinfo puzzles.info{,-1,-2,-3}
		dodoc puzzles.pdf puzzles.ps puzzles.txt
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
