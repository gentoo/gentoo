# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

COMMIT=243de72e09ddd5cdc4863613af8b749827a5e1cd

DESCRIPTION="Emacs mode for editing and previewing Graphviz dot graphs"
HOMEPAGE="http://users.skynet.be/ppareit/projects/graphviz-dot-mode/graphviz-dot-mode.html
	https://github.com/ppareit/graphviz-dot-mode
	https://www.graphviz.org/"
SRC_URI="https://github.com/ppareit/graphviz-dot-mode/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

SITEFILE="50${PN}-gentoo.el"

S="${WORKDIR}/${PN}-${COMMIT}"
