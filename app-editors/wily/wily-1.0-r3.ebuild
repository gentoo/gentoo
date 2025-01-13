# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

MY_P="${P/1.0/9libs}"

DESCRIPTION="An emulation of ACME, Plan9's hybrid window system, shell and editor"
HOMEPAGE="https://www.netlib.org/research/9libs/"
SRC_URI="https://www.netlib.org/research/9libs/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

DEPEND="
	dev-libs/9libs
"
RDEPEND="
	${DEPEND}
"
DOCS=(
	README
)

PATCHES=( "${FILESDIR}/${P}-C23.patch" )

src_prepare() {
	default

	#bug https://bugs.gentoo.org/877123 and https://bugs.gentoo.org/906022
	eautoreconf
}

src_configure() {
	mhw_cv_mod_9libs_lib_path=/usr/$(get_libdir) \
	mhw_cv_mod_9libs_inc_path=/usr/include/9libs \
	econf
}

src_install() {
	default

	insinto /usr/share/${PN}
	doins "${S}"/misc/*
}
