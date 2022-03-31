# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit fortran-2

MY_P=${PN}-v.${PV}

DESCRIPTION="HF propagation prediction tool"
HOMEPAGE="https://www.qsl.net/hz1jw/voacapl/index.html"
SRC_URI="https://github.com/jawatson/${PN}/archive/v.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="mirror bindist"

S="${WORKDIR}/${MY_P}"

src_compile() {
	# bug 513766
	emake -j1
}
