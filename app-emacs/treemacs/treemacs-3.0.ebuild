# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Tree style project file explorer"
HOMEPAGE="https://github.com/Alexander-Miller/treemacs/"
SRC_URI="https://github.com/Alexander-Miller/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/ace-window
	app-emacs/cfrs
	app-emacs/dash
	app-emacs/ht
	app-emacs/hydra
	app-emacs/pfuture
	app-emacs/s
"
BDEPEND="
	${RDEPEND}
	test? ( app-emacs/buttercup )
"

DOCS=( Changelog.org Extensions.org README.org screenshots )
PATCHES=(
	"${FILESDIR}"/${PN}-icons-icon-directory.patch
	"${FILESDIR}"/${PN}-tests.patch
)

BYTECOMPFLAGS="-L . -L src/elisp"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${SITEETC}/${PN}|" -i src/elisp/${PN}-icons.el || die
}

src_compile() {
	elisp-compile src/elisp/*.el
}

src_test() {
	buttercup ${BYTECOMPFLAGS} -L test --traceback full || die
}

src_install() {
	elisp-install ${PN} src/elisp/*.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	insinto ${SITEETC}/${PN}
	doins -r icons
}
