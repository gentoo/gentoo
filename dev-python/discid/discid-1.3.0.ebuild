# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P=python-discid-${PV}
DESCRIPTION="Python bindings for libdiscid"
HOMEPAGE="
	https://python-discid.readthedocs.io/en/latest/
	https://github.com/metabrainz/python-discid/
	https://pypi.org/project/discid/
"
SRC_URI="
	https://github.com/metabrainz/python-discid/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86"

DEPEND="
	>=media-libs/libdiscid-0.2.2
"
RDEPEND="
	${DEPEND}
"

distutils_enable_sphinx doc

python_test() {
	"${EPYTHON}" -m unittest -v test_discid.TestModule{Private,} ||
		die "Tests failed with ${EPYTHON}"
}
