# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Detachable minimap for Emacs"
HOMEPAGE="https://gitlab.com/sawyerjgardner/demap.el/"
SRC_URI="https://gitlab.com/sawyerjgardner/${PN}.el/-/archive/v${PV}/${PN}.el-v${PV}.tar.gz"
S="${WORKDIR}"/${PN}.el-v${PV}

LICENSE="GPL-3+"
KEYWORDS="amd64 x86"
SLOT="0"

# "make test" is just a practical check if "demap-open" works, maintainers of
# this package could check themselves if it still works after installation.
# Notice that we autolaod only the "demap-toggle" function (not "demap-open").
RESTRICT="test"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
