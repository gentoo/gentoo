# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Emacs mode for editing and previewing Graphviz dot graphs"
HOMEPAGE="http://users.skynet.be/ppareit/projects/graphviz-dot-mode/graphviz-dot-mode.html
	https://github.com/ppareit/graphviz-dot-mode
	http://www.graphviz.org/"
SRC_URI="https://github.com/ppareit/graphviz-dot-mode/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

SITEFILE="50${PN}-gentoo.el"
