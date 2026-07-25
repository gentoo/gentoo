# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Use avy to jump to Embark Collect entries"
HOMEPAGE="https://github.com/oantolin/embark/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/oantolin/embark/"
else
	SRC_URI="https://github.com/oantolin/embark/archive/${PV}.tar.gz
		-> embark-${PV}.gh.tar.gz"
	S="${WORKDIR}/embark-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/embark-1.2
	app-emacs/avy
"
BDEPEND="
	${RDEPEND}
"

ELISP_REMOVE="embark-consult.el embark-org.el embark.el"
SITEFILE="50${PN}-gentoo.el"
