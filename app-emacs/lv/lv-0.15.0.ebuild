# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

IUSE=""

DESCRIPTION="Other echo area"
HOMEPAGE="https://github.com/abo-abo/hydra"
SRC_URI="https://github.com/abo-abo/hydra/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
DOCS="README.md"

SITEFILE="50${PN}-gentoo.el"

S="${WORKDIR}/hydra-${PV}"
