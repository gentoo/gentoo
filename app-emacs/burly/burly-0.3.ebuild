# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Save and restore frames and windows with their buffers in Emacs"
HOMEPAGE="https://github.com/alphapapa/burly.el"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alphapapa/${PN}.el.git"
else
	SRC_URI="https://github.com/alphapapa/${PN}.el/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}.el-${PV}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile

	elisp-make-autoload-file
}

src_install() {
	elisp_src_install

	doinfo ${PN}.info
}
