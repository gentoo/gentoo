# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="YAML parser in Emacs Lisp"
HOMEPAGE="https://github.com/zkry/yaml.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/zkry/yaml.el"
else
	SRC_URI="https://github.com/zkry/yaml.el/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/yaml.el-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}" -L . -l yaml-tests.el
