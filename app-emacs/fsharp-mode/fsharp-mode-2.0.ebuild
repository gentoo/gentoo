# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Support for the F# programming language"
HOMEPAGE="https://github.com/fsharp/emacs-fsharp-mode/"
SRC_URI="https://github.com/fsharp/emacs-${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( CHANGELOG.md README.org )
ELISP_REMOVE="eglot-fsharp.el test/integration-tests.el"
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup test
