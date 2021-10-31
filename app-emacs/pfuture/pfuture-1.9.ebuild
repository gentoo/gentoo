# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A simpler wrapper around emacs process creation functions"
HOMEPAGE="https://github.com/Alexander-Miller/pfuture"
SRC_URI="https://github.com/Alexander-Miller/pfuture/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

SITEFILE="50pfuture-gentoo.el"
DOCS=( README.org )

src_compile() {
	elisp-make-autoload-file "${S}/${PN}-autoload.el" "${S}/"
	elisp_src_compile
}
