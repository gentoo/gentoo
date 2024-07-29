# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1
DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 elisp

DESCRIPTION="Tree style project file explorer"
HOMEPAGE="https://github.com/Alexander-Miller/treemacs/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Alexander-Miller/${PN}.git"
else
	SRC_URI="https://github.com/Alexander-Miller/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-editors/emacs-${NEED_EMACS}[svg]
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
"

BYTECOMPFLAGS="-L . -L src/elisp"
PATCHES=(
	"${FILESDIR}/${PN}-2.9.5-tests.patch"
	"${FILESDIR}/${PN}-async-scripts.patch"
	"${FILESDIR}/${PN}-icons-icon-directory.patch"
)

DOCS=( Changelog.org Extensions.org README.org screenshots )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup test

src_prepare() {
	distutils-r1_src_prepare

	sed "s|@SITEETC@|${SITEETC}/${PN}|g"		\
		-i "src/elisp/${PN}-icons.el"			\
		-i "src/elisp/${PN}-async.el" || die
}

python_compile() {
	python_optimize "${S}/src/scripts"
}

src_compile() {
	distutils-r1_src_compile

	elisp-compile src/elisp/*.el
}

src_install() {
	elisp-install "${PN}" src/elisp/*.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	insinto "${SITEETC}/${PN}"
	doins -r icons
	doins -r src/scripts
}
