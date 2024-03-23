# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp font readme.gentoo-r1

DESCRIPTION="Emacs Nerd Font Icons Library"
HOMEPAGE="https://github.com/rainstormstudio/nerd-icons.el/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rainstormstudio/${PN}.el.git"
else
	SRC_URI="https://github.com/rainstormstudio/${PN}.el/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"

	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

FONT_PN="NFM"
FONT_S="${S}/fonts"
FONT_SUFFIX="ttf"

DOC_CONTENTS="You may need to install the required fonts by executing
	the \"nerd-icons-install-fonts\" function."
SITEFILE="50${PN}-gentoo.el"

pkg_setup() {
	elisp_pkg_setup
	font_pkg_setup
}

src_compile() {
	elisp_src_compile

	elisp-make-autoload-file
	elisp-compile data/*.el
}

src_install() {
	elisp_src_install
	font_src_install

	elisp-install "${PN}/data" data/*.el{,c}
}

pkg_postinst() {
	elisp_pkg_postinst
	font_pkg_postinst
}

pkg_postrm() {
	elisp_pkg_postrm
	font_pkg_postrm
}
