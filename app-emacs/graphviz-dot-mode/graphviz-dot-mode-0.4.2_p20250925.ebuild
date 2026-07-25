# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Emacs mode for editing and previewing Graphviz dot graphs"
HOMEPAGE="http://users.skynet.be/ppareit/projects/graphviz-dot-mode/graphviz-dot-mode.html
	https://www.graphviz.org/
	https://github.com/ppareit/graphviz-dot-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ppareit/${PN}"
else
	[[ "${PV}" == *20250925 ]] && COMMIT="516c151b845a3eb2da73eb4ee648ad99172087ac"

	SRC_URI="https://github.com/ppareit/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	>=app-emacs/flycheck-36.0
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.md CHANGELOG.md )
SITEFILE="50${PN}-gentoo.el"
