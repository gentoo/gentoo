# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="A Python wrapper for the Amazon web API"
HOMEPAGE="http://www.josephson.org/projects/pyamazon"
SRC_URI="http://www.josephson.org/projects/${PN}/files/${P}.zip"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	edos2unix amazon.py
}

src_install() {
	python_domodule amazon.py
}
