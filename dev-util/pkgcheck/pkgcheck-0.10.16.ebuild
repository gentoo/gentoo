# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit elisp-common distutils-r1 optfeature

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pkgcheck.git"
	inherit git-r3
else
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="pkgcore-based QA utility for ebuild repos"
HOMEPAGE="https://github.com/pkgcore/pkgcheck"

LICENSE="BSD MIT"
SLOT="0"
IUSE="emacs"

if [[ ${PV} == *9999 ]]; then
	RDEPEND="
		~dev-python/snakeoil-9999[${PYTHON_USEDEP}]
		~sys-apps/pkgcore-9999[${PYTHON_USEDEP}]"
else
	RDEPEND="
		>=dev-python/snakeoil-0.10.1[${PYTHON_USEDEP}]
		>=sys-apps/pkgcore-0.12.15[${PYTHON_USEDEP}]"
fi
RDEPEND+="
	dev-libs/tree-sitter
	dev-libs/tree-sitter-bash
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pathspec[${PYTHON_USEDEP}]
	>=dev-python/tree-sitter-0.19.0[${PYTHON_USEDEP}]
	emacs? (
		>=app-editors/emacs-24.1:*
		app-emacs/ebuild-mode
		app-emacs/flycheck
	)
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

SITEFILE="50${PN}-gentoo.el"

distutils_enable_tests setup.py

export USE_SYSTEM_TREE_SITTER_BASH=1

src_compile() {
	distutils-r1_src_compile

	if use emacs ; then
	   pushd "${S}"/contrib/emacs >/dev/null || die
	   elisp-compile *.el
	   popd >/dev/null || die
	fi
}

src_test() {
	local -x PYTHONDONTWRITEBYTECODE=
	distutils-r1_src_test
}

python_install_all() {
	local DOCS=( NEWS.rst )
	[[ ${PV} == *9999 ]] || doman man/*
	distutils-r1_python_install_all

	if use emacs ; then
		elisp-install ${PN} "${S}"/contrib/emacs/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen

	optfeature "Network check support" dev-python/requests
	optfeature "Perl module version check support" dev-perl/Gentoo-PerlMod-Version
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
