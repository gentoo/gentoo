# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="HTTP library with curl backend for GNU Emacs"
HOMEPAGE="https://github.com/alphapapa/plz.el/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alphapapa/plz.el.git"
else
	SRC_URI="https://github.com/alphapapa/plz.el/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/plz.el-${PV}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
PROPERTIES="test_network"   # Tests require network access.
RESTRICT="test"

RDEPEND="net-misc/curl"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert tests -l tests/test-plz.el

src_install() {
	elisp_src_install

	doinfo ${PN}.info
}
