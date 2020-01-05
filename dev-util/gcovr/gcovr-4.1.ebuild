# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A Python script for summarizing gcov data"
HOMEPAGE="https://github.com/gcovr/gcovr"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/gcovr/gcovr/archive/${PV}.tar.gz -> ${P}.tar.gz"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# a bunch of "unknown module" failures
RESTRICT="test"

python_test() {
	mkdir "${T}/bin" || die
	printf -- "#!/bin/bash\nexec PYTHONPATH=\"%s\" python -c 'import gcovr.__main__; gcovr.__main__.main()' -- \"${@}\"" \
		"${BUILD_DIR}/lib" \
		> "${T}/bin/gcovr"

	chmod 755 "${T}/bin/gcovr" || die

	PATH="${T}/bin:${PATH}" ${EPYTHON} -m pytest -vv || die
}
