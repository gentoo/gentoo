# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit autotools python-r1

DESCRIPTION="Tiny library providing a C \"class\" for working with arbitrary big sizes in bytes"
HOMEPAGE="https://github.com/storaged-project/libbytesize"
SRC_URI="https://github.com/storaged-project/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ia64 ~mips ppc ppc64 sparc x86"
IUSE="doc test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/gmp:0=
	dev-libs/mpfr:=
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
	python_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--without-python3 #634840
		$(use_with doc gtk-doc)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake install DESTDIR="${D}"

	python_install() {
		emake -C src/python install DESTDIR="${D}"
		python_optimize
	}
	python_foreach_impl python_install

	find "${ED}" -name "*.la*" -delete || die
}
