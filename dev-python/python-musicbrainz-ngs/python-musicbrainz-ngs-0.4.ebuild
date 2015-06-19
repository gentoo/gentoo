# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-musicbrainz-ngs/python-musicbrainz-ngs-0.4.ebuild,v 1.6 2015/04/08 08:05:18 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="This library implements webservice bindings for the Musicbrainz NGS site"
HOMEPAGE="https://github.com/alastair/python-musicbrainz-ngs"
SRC_URI="https://github.com/alastair/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="BSD-2 ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=(README.md CHANGES)
use examples && DOCS+=( examples )

PATCHES=(
	"${FILESDIR}/${P}-fix-package_data-placement.patch"
	)

python_test() {
	"${PYTHON}" setup.py test || die
}
