# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

COMMIT="694defa220113d0acaa78fd646dcff9f1a08fad9"
DESCRIPTION="Inverse of rx: convert Emacs string regexps to rx form"
HOMEPAGE="https://github.com/mattiase/xr"
SRC_URI="https://github.com/mattiase/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert

src_install() {
	elisp-install ${PN} xr.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc README NEWS
}
