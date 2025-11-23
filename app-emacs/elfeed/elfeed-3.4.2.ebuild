# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs web feeds client"
HOMEPAGE="https://github.com/skeeto/elfeed/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/skeeto/${PN}.git"
else
	SRC_URI="https://github.com/skeeto/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="Unlicense"
SLOT="0"

RDEPEND="
	net-misc/curl[ssl]
"

ELISP_REMOVE="${PN}-pkg.el"

DOCS=( NEWS.md README.md )
SITEFILE="50${PN}-gentoo.el"
