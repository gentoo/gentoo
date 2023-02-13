# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="sqlite?"
DISTUTILS_USE_PEP517=hatchling
DISTUTILS_SINGLE_IMPL=1

inherit bash-completion-r1 distutils-r1 multiprocessing optfeature

DESCRIPTION="Check websites for broken links"
HOMEPAGE="https://github.com/linkcheck/linkchecker"
SRC_URI="https://github.com/linkchecker/linkchecker/releases/download/v${PV}/LinkChecker-${PV}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
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
			dev-python/parameterized[${PYTHON_USEDEP}]
			dev-python/pyftpdlib[${PYTHON_USEDEP}]
			dev-python/pyopenssl[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		')
		sys-devel/gettext
	)
"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}/${PN}-9.3-bash-completion.patch" )

DOCS=(
	doc/changelog.txt
	doc/upgrading.txt
)

python_test() {
	# Telnet test uses miniboa which is not available in Gentoo
	rm -f tests/checker/test_telnet.py
	# Multiple warnings about unclosed test sockets with epytest
	pytest -vra -n "$(makeopts_jobs)"|| die
}

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp config/linkchecker-completion ${PN}
}

pkg_postinst() {
	optfeature "Virus scanning" app-antivirus/clamav
	optfeature "Check links in PDF files" app-text/pdfminer
	optfeature "bash-completion support" dev-python/argcomplete
}
