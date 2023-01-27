# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Display all-the-icons icon for each file in Emacs' dired buffer"
HOMEPAGE="https://github.com/wyuenho/all-the-icons-dired/"
SRC_URI="https://github.com/wyuenho/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="app-emacs/all-the-icons"
BDEPEND="${RDEPEND}"

DOCS=( README.org logo.png )
SITEFILE="50${PN}-gentoo.el"
