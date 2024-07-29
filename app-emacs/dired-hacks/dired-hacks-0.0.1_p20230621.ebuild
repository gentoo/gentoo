# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Collection of useful dired additions for GNU Emacs"
HOMEPAGE="https://github.com/Fuco1/dired-hacks/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Fuco1/${PN}.git"
else
	[[ ${PV} == *_p20230621 ]] && COMMIT=874449d6fc98aee565e1715ec18acec3c1c2cafb
	SRC_URI="https://github.com/Fuco1/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test"  # Tests fail.

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	app-emacs/dash
	app-emacs/eimp
	app-emacs/f
	app-emacs/s
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/assess
		app-emacs/shut-up
	)
"

elisp-enable-tests buttercup tests

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
