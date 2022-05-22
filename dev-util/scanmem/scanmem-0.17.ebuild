# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit autotools python-single-r1

DESCRIPTION="Locate and modify variables in executing processes"
HOMEPAGE="https://github.com/scanmem/scanmem"
SRC_URI="https://github.com/scanmem/scanmem/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="gui static-libs"

DEPEND="sys-libs/readline:="
RDEPEND="${DEPEND}
	gui? (
		${PYTHON_DEPS}
		dev-python/pygobject:3
		sys-auth/polkit
	)"

REQUIRED_USE="gui? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use gui && python-single-r1_pkg_setup
}

src_prepare() {
	default

	sed -i "/CFLAGS/d" Makefile.am || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-readline
		$(use_enable gui)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use gui ; then
		docinto gui
		dodoc gui/{README,TODO}
		python_fix_shebang "${ED}"
	fi

	find "${ED}" -type f -name "*.la" -delete || die
}
