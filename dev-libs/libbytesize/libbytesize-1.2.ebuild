# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit autotools python-single-r1

DESCRIPTION="Tiny library providing a C \"class\" for working with arbitrary big sizes in bytes"
HOMEPAGE="https://github.com/rhinstaller/libbytesize"
SRC_URI="https://github.com/rhinstaller/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/gmp:0=
	>=dev-libs/libpcre-8.32
"

DEPEND="
	${RDEPEND}
	sys-devel/gettext
	doc? ( dev-util/gtk-doc )
	test? (
		dev-python/pocketlint
		dev-python/polib
	)
"

RESTRICT="test"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with doc gtk-doc)
	)
	econf "${myeconfargs[@]}"
}
