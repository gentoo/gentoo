# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 3-0 )
inherit autotools guile

DESCRIPTION="An SQL database interface for Guile"
HOMEPAGE="https://github.com/opencog/guile-dbi/"
SRC_URI="https://github.com/opencog/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}"/${PN}-${P}/${PN}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	${GUILE_DEPS}
	dev-libs/libltdl
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/guile-dbi-2.1.9-find-correct-site-dir.patch
)

src_prepare() {
	guile_src_prepare

	eautoreconf
}

src_install() {
	guile_src_install

	find "${ED}" -type f -name "*.la" -delete || die
}
