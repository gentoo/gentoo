# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Growl Notification Protocol for GNU Emacs"
HOMEPAGE="https://github.com/tekai/gntp.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tekai/${PN}.el"
else
	SRC_URI="https://github.com/tekai/${PN}.el/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
	elisp-make-site-file "${SITEFILE}"
}
