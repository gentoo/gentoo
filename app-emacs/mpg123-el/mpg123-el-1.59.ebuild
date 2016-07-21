# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp toolchain-funcs

DESCRIPTION="Emacs front-end to mpg123 audio player and OggVorbis audio player"
HOMEPAGE="http://www.gentei.org/~yuuji/software/mpg123el/"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="mpg123-el"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="vorbis"

RDEPEND="media-sound/mpg123
	media-sound/alsa-utils
	vorbis? ( media-sound/vorbis-tools )"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	sed -i -e "s/\(mainloop:\)/\1 ;/" tagput.c || die
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o tagput tagput.c || die
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o id3put id3put.c || die
	elisp-compile *.el
}

src_install() {
	dobin tagput id3put
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
