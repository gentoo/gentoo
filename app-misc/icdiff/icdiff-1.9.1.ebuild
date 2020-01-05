# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Colourized diff that supports side-by-side diffing"
HOMEPAGE="https://www.jefftk.com/icdiff"
SRC_URI="https://github.com/jeffkaufman/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64"

DOCS=(README.md ChangeLog)

S="${WORKDIR}/${PN}-release-${PV}"

python_test() {
	./test.sh "${EPYTHON%.*}" || die "Tests failed"
}
