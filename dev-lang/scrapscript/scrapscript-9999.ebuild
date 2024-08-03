# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 edo

DESCRIPTION="Functional, content-addressable programming language"
HOMEPAGE="https://scrapscript.org/
	https://github.com/tekknolagi/scrapscript/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_BRANCH="trunk"
	EGIT_REPO_URI="https://github.com/tekknolagi/${PN}.git"
else
	inherit pypi

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

python_test() {
	edo "${EPYTHON}" ./scrapscript.py test
}
