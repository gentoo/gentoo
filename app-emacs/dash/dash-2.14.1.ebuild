# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp

DESCRIPTION="A modern list library for Emacs"
HOMEPAGE="https://github.com/magnars/dash.el"
SRC_URI="https://github.com/magnars/dash.el/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86 ~amd64-linux ~x86-linux"

DEPEND="sys-apps/texinfo"

S="${WORKDIR}/${PN}.el-${PV}"
SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="dash.texi"
DOCS="README.md"

src_test() {
	./run-tests.sh || die
}
