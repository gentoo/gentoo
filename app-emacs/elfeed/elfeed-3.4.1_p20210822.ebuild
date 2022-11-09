# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Emacs web feeds client"
HOMEPAGE="https://github.com/skeeto/elfeed/"

if [[ ${PV} == *_p* ]] ; then
	H=162d7d545ed41c27967d108c04aa31f5a61c8e16
	SRC_URI="https://github.com/skeeto/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${H}
else
	SRC_URI="https://github.com/skeeto/${PN}/releases/download/${PV}/${P}.tar"
fi

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-misc/curl[ssl]"

DOCS=( NEWS.md README.md )
ELISP_REMOVE="${PN}-pkg.el"
SITEFILE="50${PN}-gentoo.el"
