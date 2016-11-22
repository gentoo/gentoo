# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="A tiny but valid init for containers"
HOMEPAGE="https://github.com/krallin/${PN}"
SRC_URI="https://github.com/krallin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

# vim-core is needed just for the xxd program
DEPEND="app-editors/vim-core"

src_compile() {
	append-cflags -DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	if use static; then
		mv "${ED%/}"/usr/bin/{${PN}-static,${PN}} || die
	else
		rm "${ED%/}"/usr/bin/${PN}-static || die
	fi
}
