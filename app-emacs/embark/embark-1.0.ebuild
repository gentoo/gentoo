# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp optfeature

DESCRIPTION="Conveniently act on minibuffer completions inside GNU Emacs"
HOMEPAGE="https://github.com/oantolin/embark/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/oantolin/${PN}.git"
else
	SRC_URI="https://github.com/oantolin/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND=">=app-emacs/compat-29.1.4.0"
BDEPEND="${RDEPEND}"

ELISP_REMOVE="avy-embark-collect.el embark-consult.el"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile

	elisp-make-autoload-file
}

src_install() {
	elisp_src_install

	doinfo ${PN}.texi
}

pkg_postinst() {
	elisp_pkg_postinst

	optfeature "Avy integration for Embark" app-emacs/avy-embark-collect
	optfeature "Consult integration for Embark" app-emacs/embark-consult
}
