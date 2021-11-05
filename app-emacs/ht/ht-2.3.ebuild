# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

IUSE=""

DESCRIPTION="The missing hash table library for Emacs"
HOMEPAGE="https://github.com/Wilfred/ht.el"
SRC_URI="https://github.com/Wilfred/ht.el/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
DOCS="CHANGELOG.md README.md"

SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	>=app-emacs/dash-2.12.0
"
DEPEND=${RDEPEND}

S="${WORKDIR}/ht.el-${PV}"

# Requires unpackaged dependencies, e.g. Cask
RESTRICT="test"
