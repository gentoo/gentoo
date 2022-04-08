# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN}.el
NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Simple mocking framework for Emacs "
HOMEPAGE="https://github.com/sigma/mocker.el/"
SRC_URI="https://github.com/sigma/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${PV}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.markdown )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS} \
			 -L ./test -l ./test/mocker-test.el \
			 -f ert-run-tests-batch-and-exit || die "tests failed"
}
