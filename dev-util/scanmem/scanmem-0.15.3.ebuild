# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit autotools eutils python-single-r1

DESCRIPTION="Locate and modify variables in executing processes"
HOMEPAGE="https://github.com/scanmem/scanmem"
SRC_URI="https://github.com/scanmem/scanmem/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"

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
	sed -i "/CFLAGS/d" Makefile.am || die

	eautoreconf
}

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		$(use_enable gui)
}

src_install() {
	default

	if use gui ; then
		docinto gui
		dodoc gui/{README,TODO}
		python_fix_shebang "${D}"
	fi
}
