# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="2aae2fbd4971dff965c758ec19688780ed7bff21"

NEED_EMACS="26.1"

inherit elisp

DESCRIPTION="Emacs major mode for ReScript"
HOMEPAGE="https://github.com/jjlee/rescript-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/jjlee/${PN}.git"
else
	SRC_URI="https://github.com/jjlee/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md error.png typeinfo.png )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test
