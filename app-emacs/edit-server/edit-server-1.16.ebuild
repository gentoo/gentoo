# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

MY_PN="emacs_chrome"
DESCRIPTION="Service edit requests from a web browser for editing of textareas"
HOMEPAGE="https://github.com/stsquad/emacs_chrome"
SRC_URI="https://github.com/stsquad/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}/servers"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ELISP_REMOVE="edit-server-ert.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="README"
