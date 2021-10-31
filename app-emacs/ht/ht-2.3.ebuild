# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="The missing hash table library for Emacs"
HOMEPAGE="https://github.com/Wilfred/ht.el"
SRC_URI="https://github.com/Wilfred/ht.el/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}.el-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # test requires cask and ert-runner which are not packaged yet

RDEPEND=">=app-emacs/dash-2.12.0"
DEPEND="${RDEPEND}"

SITEFILE="50ht-gentoo.el"
DOCS=( README.md CHANGELOG.md )
