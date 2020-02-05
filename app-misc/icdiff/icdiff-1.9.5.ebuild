# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Colourized diff that supports side-by-side diffing"
HOMEPAGE="https://www.jefftk.com/icdiff"
SRC_URI="https://github.com/jeffkaufman/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-python/flake8[${PYTHON_USEDEP}] )"

DOCS=(README.md ChangeLog)

S="${WORKDIR}/${PN}-release-${PV}"

src_test() {
	# skip gitdiff-only-newlines test (only works inside icdiff repo)
	sed -i -e "s/^check_git_diff gitdiff-only-newlines/#&/" test.sh || die

	# use writable temp directory for tests
	sed -i -e "s|/tmp/|${T}/|" test.sh || die

	distutils-r1_src_test
}

python_test() {
	./test.sh "${EPYTHON%.*}" || die "Tests failed"
}
