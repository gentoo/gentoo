# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="25.1"

inherit elisp

DESCRIPTION="A project interaction library for Emacs"
HOMEPAGE="https://docs.projectile.mx"
SRC_URI="https://github.com/bbatsov/projectile/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

SITEFILE="50projectile-gentoo.el"
DOCS=( README.md )
RESTRICT="test" # tests require buttercup which is not packaged

src_install() {
	elisp-make-autoload-file "${S}"/${PN}-autoload.el "${S}"/
	elisp_src_install
}
