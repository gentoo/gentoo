# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

COMMIT=c456a2b65c734089e6c44e87209a5a432a741b1a

DESCRIPTION="Emacs mode for editing and previewing Graphviz dot graphs"
HOMEPAGE="http://users.skynet.be/ppareit/projects/graphviz-dot-mode/graphviz-dot-mode.html
	https://github.com/ppareit/graphviz-dot-mode
	https://www.graphviz.org/"
SRC_URI="https://github.com/ppareit/graphviz-dot-mode/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

SITEFILE="50${PN}-gentoo.el"

S="${WORKDIR}/${PN}-${COMMIT}"
