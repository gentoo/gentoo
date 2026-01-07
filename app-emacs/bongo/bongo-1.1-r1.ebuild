# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Buffer-oriented media player for Emacs"
HOMEPAGE="https://www.emacswiki.org/emacs/Bongo"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/dbrock/${PN}"
else
	SRC_URI="https://github.com/dbrock/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

SRC_URI+="
	mplayer? (
		mirror://gentoo/${PN}-mplayer-20070204.tar.bz2
	)
"

LICENSE="GPL-2+ FDL-1.2+"
SLOT="0"
IUSE="mplayer"

# NOTE: Bongo can use almost anything for playing media files, therefore
# the dependency possibilities are so broad that we refrain from including
# any media players explicitly in DEPEND/RDEPEND.
RDEPEND="
	app-emacs/volume
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

DOCS=( NEWS README TODO tree-from-tags.rb )
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

src_unpack() {
	elisp_src_unpack

	if use mplayer ; then
		mv ${PN}/bongo-mplayer.el "${S}"/ || die
	fi
}

src_compile() {
	# volume.el calls amixer in global scope, causing a sandbox violation
	# in /dev/snd/. Work around it by disabling the mixer programs.
	cat <<-EOF >nomixer.txt || die
		(setq volume-amixer-program "/bin/false")
		(setq volume-aumix-program "/bin/false")
	EOF
	BYTECOMPFLAGS+=" -l nomixer.txt"
	elisp_src_compile
}

src_install() {
	elisp_src_install
	insinto "${SITEETC}/${PN}"
	doins images/*.pbm images/*.png
}
