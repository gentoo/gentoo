# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

MY_PN="${PN}.el"
COMMIT="08c1e2c9c2cfa00b16a05968cb553f19ec680330"
DESCRIPTION="Generic autocrypt implementation for Emacs"
HOMEPAGE="https://codeberg.org/pkal/autocrypt.el"
SRC_URI="https://codeberg.org/pkal/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DOCS=("README.md")
SITEFILE="50${PN}-gentoo.el"
