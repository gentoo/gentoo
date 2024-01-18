# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="YAML parser in Emacs Lisp"
HOMEPAGE="https://github.com/zkry/yaml.el/"
SRC_URI="https://github.com/zkry/yaml.el/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/yaml.el-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	# "test/string-inflection-test.el" calls "(ert-run-tests-batch t)"
	${EMACS} ${EMACSFLAGS} -L . -l yaml-tests.el || die
}
