# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major mode for editing files in exheres format"
HOMEPAGE="https://www.exherbo.org/
	https://gitlab.exherbo.org/exherbo-misc/exheres-mode/"
SRC_URI="https://dev.exherbo.org/distfiles/${PN}/${P}.tar.xz"
S="${WORKDIR}/${P}/src"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
