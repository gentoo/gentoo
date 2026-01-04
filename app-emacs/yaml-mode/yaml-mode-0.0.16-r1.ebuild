# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A major mode for GNU Emacs for editing YAML files"
HOMEPAGE="https://github.com/yoshiki/yaml-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/yoshiki/${PN}"
else
	SRC_URI="https://github.com/yoshiki/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~arm64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DOCS=( Changes README )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert test
