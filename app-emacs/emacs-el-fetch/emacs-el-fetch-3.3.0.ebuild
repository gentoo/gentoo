# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Show system information in Neofetch-like style inside Emacs"
HOMEPAGE="https://gitlab.com/xgqt/emacs-el-fetch/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/xgqt/${PN}.git"
else
	SRC_URI="https://gitlab.com/xgqt/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( app-emacs/buttercup )"

src_compile() {
	emake compile
}

src_install() {
	einstalldocs
	elisp-install ${PN} "${S}"/src/el-fetch/*.el{,c}
	elisp-site-file-install "${S}"/extras/gentoo/50el-fetch-gentoo.el
}
