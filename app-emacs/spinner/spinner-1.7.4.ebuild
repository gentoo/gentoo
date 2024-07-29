# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

IUSE=""

DESCRIPTION="Emacs mode-line spinner for operations in progress"
HOMEPAGE="https://github.com/Malabarba/spinner.el"
SRC_URI="https://github.com/Malabarba/spinner.el/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64"

SITEFILE="50${PN}-gentoo.el"

S="${WORKDIR}/spinner.el-${PV}"
DOCS="README.org"
