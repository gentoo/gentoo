# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Use avy to jump to Embark Collect entries"
HOMEPAGE="https://github.com/oantolin/embark/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/oantolin/embark.git"
else
	SRC_URI="https://github.com/oantolin/embark/archive/${PV}.tar.gz
		-> embark-${PV}.tar.gz"
	S="${WORKDIR}/embark-${PV}"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/avy
	app-emacs/embark
"
BDEPEND="${RDEPEND}"

ELISP_REMOVE="embark-consult.el embark-org.el embark.el"

SITEFILE="50${PN}-gentoo.el"
