# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

MY_COMMIT=4f8553632d71e827b4da6e091143779d2ad970a8
DESCRIPTION="Practice touch and speed typing"
HOMEPAGE="https://github.com/dakra/speed-type"
SRC_URI="https://github.com/dakra/speed-type/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-emacs/compat-29.1"
DEPEND="${RDEPEND}"

SITEFILE=50${PN}-gentoo.el

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
