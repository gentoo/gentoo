# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Mocking library for Emacs"
HOMEPAGE="https://github.com/rejeep/el-mock.el/"
SRC_URI="https://github.com/rejeep/${PN}.el/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${PV}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
