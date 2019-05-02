# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit autotools python-any-r1

DESCRIPTION="Tiny library providing a C \"class\" for working with arbitrary big sizes in bytes"
HOMEPAGE="https://github.com/storaged-project/libbytesize"
SRC_URI="https://github.com/storaged-project/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc test tools"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/gmp:0=
	dev-libs/mpfr:=
	dev-libs/libpcre2
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

DOCS=( NEWS.rst README.md )

RESTRICT="test"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-python3
		$(use_with doc gtk-doc)
		$(use_with tools)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	python_optimize
	find "${ED}" -name "*.la*" -delete || die
}
