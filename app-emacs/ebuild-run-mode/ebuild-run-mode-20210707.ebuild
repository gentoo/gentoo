# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS="24.5"

inherit elisp

MY_PN="emacs-${PN}"
DESCRIPTION="Major mode for Emacs buffers where ebuild commands run"
HOMEPAGE="https://gitlab.com/akater/emacs-ebuild-run-mode"
SRC_URI="https://gitlab.com/akater/${MY_PN}/-/archive/v${PV}/${MY_PN}-v${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-v${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-emacs/ebuild-mode-1.53"

SITEFILE="50${PN}-gentoo.el"
DOCS="ebuild-run-mode.org"

src_compile() {
	default
}
