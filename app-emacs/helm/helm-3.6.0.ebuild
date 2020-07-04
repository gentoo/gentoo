# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Emacs incremental completion and selection narrowing framework"
HOMEPAGE="https://emacs-helm.github.io/helm/"
SRC_URI="https://github.com/emacs-helm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/async
	app-emacs/popup"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}

src_install() {
	elisp_src_install
	exeinto "${SITEETC}/${PN}"
	doexe emacs-helm.sh
}
