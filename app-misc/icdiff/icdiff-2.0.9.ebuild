# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Colourized diff that supports side-by-side diffing"
HOMEPAGE="https://www.jefftk.com/icdiff"
SRC_URI="https://github.com/jeffkaufman/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

PATCHES=(
	"${FILESDIR}/icdiff-1.9.5-tests.patch"
	"${FILESDIR}/icdiff-2.0.7-tests.patch"
)

DOCS=( README.md ChangeLog )

python_test() {
	bash test.sh "${EPYTHON%.*}" || die "Tests failed with ${EPYTHON}"
}
