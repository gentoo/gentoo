# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Paste parts of buffers to several pastebin-like services from Emacs"
HOMEPAGE="https://github.com/etu/webpaste.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/etu/${PN}.el.git"
else
	SRC_URI="https://github.com/etu/${PN}.el/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test"         # Old tests, w/o lexical-binding needed by buttercup >=1.34.

RDEPEND="
	app-emacs/request
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/undercover
	)
"

# Remove failing tests
ELISP_REMOVE="
	tests/integration/test-webpaste-providers.el
	tests/unit/test-webpaste-provider-creation.el
"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup tests
