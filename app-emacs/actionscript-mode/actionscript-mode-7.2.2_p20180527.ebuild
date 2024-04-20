# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

COMMIT="65abd58e198458a8e46748c5962c41d80d60c4ea"
DESCRIPTION="A major mode for GNU Emacs for editing Actionscript 3 files"
HOMEPAGE="https://github.com/austinhaas/actionscript-mode"
SRC_URI="https://github.com/austinhaas/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}-${COMMIT}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
