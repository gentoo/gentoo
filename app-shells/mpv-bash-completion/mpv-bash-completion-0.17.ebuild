# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit bash-completion-r1

DESCRIPTION="Bash completion for the mpv video player"
HOMEPAGE="https://2ion.github.io/mpv-bash-completion/"
SRC_URI="https://github.com/2ion/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-video/mpv[cli]"
RDEPEND="${DEPEND}
	>=app-shells/bash-completion-2.3-r1
"

DOCS=( KNOWN_BUGS README.mkd )

src_compile() {
	"${S}"/gen.sh > ${PN} || die
}

src_install() {
	einstalldocs
	newbashcomp ${PN} mpv
}
