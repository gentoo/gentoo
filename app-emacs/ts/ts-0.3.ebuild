# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs timestamp and date-time library"
HOMEPAGE="https://github.com/alphapapa/ts.el"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/alphapapa/ts.el.git"
else
	[[ "${PV}" == 0.3 ]] && COMMIT=552936017cfdec89f7fc20c254ae6b37c3f22c5b
	SRC_URI="https://github.com/alphapapa/ts.el/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/ts.el-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/dash
	app-emacs/s
"
BDEPEND="
	${RDEPEND}
	test? (
		sys-libs/timezone-data
	)
"

PATCHES=( "${FILESDIR}/ts-0.3-test.patch" )

DOCS=( README.org notes.org )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	LANG=C TZ=/usr/share/zoneinfo/UTC elisp-test-ert test -l test/test.el
}
