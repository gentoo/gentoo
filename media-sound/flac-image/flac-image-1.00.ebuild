# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/flac-image/flac-image-1.00.ebuild,v 1.2 2012/08/15 23:26:28 flameeyes Exp $

EAPI=4

inherit eutils

DESCRIPTION="Utility for stuffing image files (e.g. album cover art) into metadata blocks in FLAC files"
HOMEPAGE="http://www.singingtree.com/software/"
SRC_URI="http://www.singingtree.com/software/${PN}.tar.gz -> ${P}.tar.gz"
# FIXME: no version in tarball, but also no updates for a long time. So it's ok.
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/flac"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

# compile helper
_compile() {
	local CC="$(tc-getCC)"
	echo "${CC} ${@}" && "${CC}" "${@}"
}

src_prepare() {
	sed -i -e "s:^\(#include <stdio.h>\):\1\n#include <string.h>:g" "${PN}.c"
	rm -f -- "${PN}"  # remove pre-compiled binary
}

src_compile() {
	# Makefile is both simple and broken, so we compile the binary ourself.
	_compile ${CFLAGS} ${LDFLAGS} -o "${PN}" "${PN}.c" -lFLAC \
	|| die "compile failed"
}

src_install() {
	dobin "${PN}"
}
