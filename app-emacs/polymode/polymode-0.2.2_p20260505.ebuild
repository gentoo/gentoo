# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Framework for Multiple Major Modes in Emacs"
HOMEPAGE="https://github.com/polymode/polymode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/polymode/${PN}"
else
	[[ "${PV}" == *20260505 ]] && COMMIT="8cb72fa5dcc0d98746c680043dc121edc7621e3a"

	SRC_URI="https://github.com/polymode/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

# The "compat-tests" downloads resources from network and "define-tests" fails
ELISP_REMOVE="
	tests/compat-tests.el
	tests/define-tests.el
"

DOCS=( readme.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert tests

src_install() {
	elisp_src_install

	dodoc -r samples
}
