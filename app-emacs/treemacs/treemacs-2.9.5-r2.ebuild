# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1
DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{8..10} )

inherit elisp distutils-r1

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
	"${FILESDIR}"/${PN}-async-scripts.patch
	"${FILESDIR}"/${PN}-icons-icon-directory.patch
	"${FILESDIR}"/${P}-tests.patch
)

BYTECOMPFLAGS="-L . -L src/elisp"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	distutils-r1_src_prepare

	sed "s|@SITEETC@|${SITEETC}/${PN}|g"        \
		-i src/elisp/${PN}-icons.el             \
		-i src/elisp/${PN}-async.el || die
}

python_compile() {
	python_optimize "${S}"/src/scripts
}

src_compile() {
	distutils-r1_src_compile
	elisp-compile src/elisp/*.el
}

src_test() {
	buttercup ${BYTECOMPFLAGS} -L test --traceback full || die "tests failed"
}

src_install() {
	elisp-install ${PN} src/elisp/*.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	insinto ${SITEETC}/${PN}
	doins -r icons
	doins -r src/scripts
}
