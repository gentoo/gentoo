# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="29.1"

inherit elisp

DESCRIPTION="Key-chord binding helper for use-package-chords"
HOMEPAGE="https://github.com/jwiegley/use-package/"
SRC_URI="https://github.com/jwiegley/use-package/archive/${PV}.tar.gz
	-> use-package-${PV}.tar.gz"
S="${WORKDIR}"/use-package-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND="app-emacs/key-chord"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile ${PN}.el
}

src_install() {
	elisp-make-site-file "${SITEFILE}"
	elisp-install ${PN} ${PN}.el{,c}
}
