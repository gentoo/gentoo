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
RDEPEND="${COMMON_DEPEND}
	>=app-shells/bash-completion-2.3-r1
"
DEPEND="${COMMON_DEPEND}
	!luajit? ( dev-lang/lua:* )
	luajit? ( dev-lang/luajit:2 )
"

src_compile() {
	$(usex luajit 'luajit' 'lua') gen.lua > ${PN} || die
}

src_install() {
	einstalldocs
	newbashcomp ${PN} mpv
}

pkg_postinst() {
	if ! has_version 'x11-apps/xrandr'; then
		echo
		elog "If you want completion of window sizes, please install x11-apps/xrandr."
		echo
	fi
}
