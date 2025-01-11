# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Make Emacs bindings that stick around"
HOMEPAGE="https://github.com/abo-abo/hydra/"
SRC_URI="https://github.com/abo-abo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="amd64 ~arm64 ~x86"
SLOT="0"

RDEPEND="app-emacs/lv"
BDEPEND="${RDEPEND}"

DOCS=( README.md doc/Changelog.org )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	emake test
}

src_install() {
	rm hydra-test.el{,c} lv.el{,c} || die
	elisp_src_install
}
