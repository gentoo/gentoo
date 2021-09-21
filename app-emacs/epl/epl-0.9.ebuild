# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NEED_EMACS="24"

inherit elisp

DESCRIPTION="A convenient high-level API for package.el"
HOMEPAGE="https://github.com/cask/epl"
SRC_URI="https://github.com/cask/epl/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # test requires cask and ert-runner which are not packaged

SITEFILE="50epl-gentoo.el"
DOCS=( README.md )
