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
IUSE="luajit"

COMMON_DEPEND="media-video/mpv[cli]"
DEPEND="${COMMON_DEPEND}
	!luajit? ( dev-lang/lua:* )
	luajit? ( dev-lang/luajit:2 )
"
RDEPEND="${COMMON_DEPEND}
	>=app-shells/bash-completion-2.3-r1
"

src_prepare() {
	default_src_prepare
	# Disable screen resolution autodetection via xrandr.
	sed -i -e '/x11ResList/{N;d;}' -e 's|, "Dimen"||' gen.lua || die
}

src_compile() {
	$(usex luajit 'luajit' 'lua') gen.lua > ${PN} || die
}

src_install() {
	einstalldocs
	newbashcomp ${PN} mpv
}
