# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Simple way to manage personal keybindings"
HOMEPAGE="https://github.com/jwiegley/use-package/"
SRC_URI="https://github.com/jwiegley/use-package/archive/${PV}.tar.gz
	-> use-package-${PV}.tar.gz"
S="${WORKDIR}"/use-package-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile ${PN}.el
}

src_install() {
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	elisp-install ${PN} ${PN}.el{,c}
}
