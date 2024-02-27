# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=b4d31c3da018cfbb3d1f9e6fd416d8777f0835bd
NEED_EMACS=29.1    # To compile full suite including Eglot, introduced in 29.1.

inherit elisp

DESCRIPTION="Support for the F# programming language"
HOMEPAGE="https://github.com/fsharp/emacs-fsharp-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fsharp/emacs-${PN}.git"
else
	SRC_URI="https://github.com/fsharp/emacs-${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/emacs-${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

DOCS=( CHANGELOG.md README.org )
ELISP_REMOVE="test/fsi-tests.el test/integration-tests.el"
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup test
