# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs web feeds client"
HOMEPAGE="https://github.com/skeeto/elfeed/"

if [[ ${PV} == *_p20210822 ]] ; then
	COMMIT=162d7d545ed41c27967d108c04aa31f5a61c8e16
	SRC_URI="https://github.com/skeeto/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
else
	SRC_URI="https://github.com/skeeto/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
fi

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="net-misc/curl[ssl]"

ELISP_REMOVE="${PN}-pkg.el"

DOCS=( NEWS.md README.md )
SITEFILE="50${PN}-gentoo.el"
