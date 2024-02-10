# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Associative data structure functions for Emacs Lisp"
HOMEPAGE="https://github.com/plexus/a.el/"
SRC_URI="https://github.com/plexus/a.el/archive/v${PV}.tar.gz
	-> a.el-${PV}.tar.gz"
S="${WORKDIR}"/a.el-${PV}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( CHANGELOG.md README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test
