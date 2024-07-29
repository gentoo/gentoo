# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools bash-completion-r1 git-r3

DESCRIPTION="A fast unix command line interface to WWW"
LICENSE="public-domain"
HOMEPAGE="
	https://gitlab.com/surfraw/Surfraw
"
EGIT_REPO_URI="https://gitlab.com/surfraw/Surfraw.git"

SLOT="0"
KEYWORDS=""
RESTRICT="test"

RDEPEND="
	dev-lang/perl
"
DOCS=(
	AUTHORS ChangeLog HACKING NEWS README TODO
)
PATCHES=(
	"${FILESDIR}"/${PN}-2.3.0-completion.patch
	"${FILESDIR}"/${PN}-99999-sr-completion-path.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --with-elvidir='$(datadir)'/surfraw
}

src_install() {
	default

	local sr_man_page
	for sr_man_page in $(find "${ED}" -lname surfraw.1.gz); do
		ln -sf surfraw.1 "${sr_man_page/.gz}" || die
		rm "${sr_man_page}" || die
	done
	for sr_man_page in $(find "${ED}" -lname elvi.1sr.gz); do
		ln -sf elvi.1sr "${sr_man_page/.gz}" || die
		rm "${sr_man_page}" || die
	done
	for sr_man_page in $(find -P "${ED}"/usr/share/man/man1/ -type f -name '*.gz'); do
		gzip -d "${sr_man_page}" || die
	done

	newbashcomp surfraw-bash-completion ${PN}
	bashcomp_alias ${PN} sr

	docinto examples
	dodoc examples/README examples/uzbl_load_url_from_surfraw
}
