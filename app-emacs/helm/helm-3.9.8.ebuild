# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs incremental completion and selection narrowing framework"
HOMEPAGE="https://emacs-helm.github.io/helm/
	https://github.com/emacs-helm/helm/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-helm/${PN}.git"
else
	SRC_URI="https://github.com/emacs-helm/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/async
	app-emacs/popup
"
BDEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-3.8.8-no-autoload-check.patch" )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}

src_install() {
	elisp_src_install

	exeinto /usr/bin/
	doexe emacs-helm.sh
}
