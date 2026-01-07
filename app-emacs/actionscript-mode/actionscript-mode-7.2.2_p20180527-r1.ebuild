# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="65abd58e198458a8e46748c5962c41d80d60c4ea"

inherit elisp

DESCRIPTION="A major mode for GNU Emacs for editing Actionscript 3 files"
HOMEPAGE="https://github.com/austinhaas/actionscript-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/austinhaas/${PN}"
else
	SRC_URI="https://github.com/austinhaas/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
