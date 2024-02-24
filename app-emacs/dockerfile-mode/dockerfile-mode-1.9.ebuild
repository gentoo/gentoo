# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="GNU Emacs mode for handling Dockerfiles"
HOMEPAGE="https://github.com/spotify/dockerfile-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/spotify/${PN}.git"
else
	SRC_URI="https://github.com/spotify/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
