# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools dot-a fortran-2

MY_P=${PN}-v.${PV}

DESCRIPTION="HF propagation prediction tool"
HOMEPAGE="https://www.qsl.net/hz1jw/voacapl/index.html"
SRC_URI="https://github.com/jawatson/${PN}/archive/v.${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 ~x86"

RESTRICT="mirror bindist"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	lto-guarantee-fat
	econf
}

src_compile() {
	# bug 513766
	emake -j1
}

src_install() {
	default
	strip-lto-bytecode
}
