# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Quickly rewrite git repository history (filter-branch replacement)"
HOMEPAGE="https://github.com/newren/git-filter-repo/"
SRC_URI="https://github.com/newren/git-filter-repo/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-vcs/git-$(ver_cut 1-2)
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

# the git-archive tarball does not have version info; setuptools-scm
# requires a valid source of version info, this one is for distros
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	cd .. || die
	bash "${S}"/t/run_tests || die
}

python_install_all() {
	distutils-r1_python_install_all

	# Just like git itself there is a manpage in troff + html formats.
	# Unlike git itself, we cannot install the html one, because the
	# `git --html-path` has the ${PV} of git in it. So just install
	# the troff copy.
	doman "${WORKDIR}"/${P}/Documentation/man1/git-filter-repo.1

	# Points to dead symlink
	rm "${ED}"/usr/share/doc/${PF}/README.md || die
	rmdir "${ED}"/usr/share/doc/${PF} || die

	dodoc "${WORKDIR}"/${P}/README.md
}
