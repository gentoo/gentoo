# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..13} )
inherit elisp-common distutils-r1 optfeature

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/pkgcore/pkgcheck.git
		https://github.com/pkgcore/pkgcheck.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
	inherit pypi
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
		>=dev-python/snakeoil-0.10.8[${PYTHON_USEDEP}]
		>=sys-apps/pkgcore-0.12.25[${PYTHON_USEDEP}]"
fi
RDEPEND+="
	>=dev-libs/tree-sitter-bash-0.21.0[python,${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pathspec[${PYTHON_USEDEP}]
	>=dev-python/tree-sitter-0.22.0[${PYTHON_USEDEP}]
	emacs? (
		>=app-editors/emacs-24.1:*
		app-emacs/ebuild-mode
		app-emacs/flycheck
	)
"
BDEPEND="${RDEPEND}
	>=dev-python/flit-core-3.8[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

SITEFILE="50${PN}-gentoo.el"

distutils_enable_tests pytest

export USE_SYSTEM_TREE_SITTER_BASH=1

src_compile() {
	distutils-r1_src_compile

	if use emacs ; then
	   pushd "${S}"/contrib/emacs >/dev/null || die
	   elisp-compile *.el
	   popd >/dev/null || die
	fi
}

python_install_all() {
	local DOCS=( NEWS.rst )
	[[ ${PV} == *9999 ]] || doman build/sphinx/man/*
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
