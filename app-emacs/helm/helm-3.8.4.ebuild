# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

PATCHES="${FILESDIR}/${PN}-3.8.0-no-autoload-check.patch"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}

src_install() {
	elisp_src_install
	dobin emacs-helm.sh
}
