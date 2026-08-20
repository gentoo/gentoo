# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit go-module python-single-r1

DESCRIPTION="Converts images from gif format to png format"
HOMEPAGE="http://catb.org/~esr/gif2png/"
SRC_URI="http://catb.org/~esr/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="${PYTHON_DEPS}"
RDEPEND="${BDEPEND}"

src_install() {
	local prefix="${EPREFIX}/usr"
	emake \
		DESTDIR="${D}" \
		PREFIX="${prefix}" \
		install
}
