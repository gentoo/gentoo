# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 pypi

DESCRIPTION="Personal shell command keeper and snippets manager"
HOMEPAGE="
	https://pypi.org/project/keep/
	https://github.com/orkohunter/keep
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/PyGithub[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/terminaltables[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" - <<-EOF || die "Smoke test failed with ${EPYTHON}"
		import datetime, sys, os
		import keep.cli, keep.utils

		# avoid automatic initialization, otherwise keep basically just creates
		# this directory and exits
		# see https://github.com/OrkoHunter/keep/blob/8dddc00aaaf0e53edbd2477a02d3fe53e38b7f28/keep/utils.py#L53-L63
		os.makedirs(keep.utils.dir_path, exist_ok=True)

		# keep tries to check newest version on pypi once a day, let's pretend
		# that this check was already done
		# see https://github.com/OrkoHunter/keep/blob/8dddc00aaaf0e53edbd2477a02d3fe53e38b7f28/keep/utils.py#L23-L50
		with open(os.path.join(keep.utils.dir_path, 'update_check.txt'), 'w') as f: f.write(datetime.date.today().strftime("%m/%d/%Y"))

		sys.exit(keep.cli.cli())
	EOF
}
