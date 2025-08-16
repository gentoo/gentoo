# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="sqlite?"
DISTUTILS_USE_PEP517=hatchling
DISTUTILS_SINGLE_IMPL=1
PYPI_NO_NORMALIZE=1
PYPI_PN=LinkChecker

inherit bash-completion-r1 distutils-r1 multiprocessing optfeature pypi

DESCRIPTION="Check websites for broken links"
HOMEPAGE="https://github.com/linkchecker/linkchecker"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sqlite"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/dnspython[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			app-text/pdfminer[${PYTHON_USEDEP}]
			dev-python/cryptography[${PYTHON_USEDEP}]
			dev-python/pyftpdlib[${PYTHON_USEDEP}]
			dev-python/pyopenssl[${PYTHON_USEDEP}]
		')
		sys-devel/gettext
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=( "${FILESDIR}/${PN}-9.3-bash-completion.patch" )

DOCS=(
	doc/changelog.txt
	doc/upgrading.txt
)

python_test() {
	# epytest overrides bs4 ignores from pytest.ini
	# and also outputs multiple warnings about unclosed test sockets
	pytest -vra -n "$(makeopts_jobs)" || die
}

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp config/linkchecker-completion ${PN}
}

pkg_postinst() {
	optfeature "Check links in PDF files" app-text/pdfminer
	optfeature "bash-completion support" dev-python/argcomplete
}
