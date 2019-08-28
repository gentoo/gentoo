# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib toolchain-funcs

MY_P="${P/1.0/9libs}"

DESCRIPTION="An emulation of ACME, Plan9's hybrid window system, shell and editor"
HOMEPAGE="https://www.netlib.org/research/9libs/"
SRC_URI="https://www.netlib.org/research/9libs/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/9libs
"
RDEPEND="
	${DEPEND}
"
DOCS=(
	README
)
S=${WORKDIR}/${MY_P}

src_configure() {
	tc-export CC

	mhw_cv_mod_9libs_lib_path=/usr/$(get_libdir) \
	mhw_cv_mod_9libs_inc_path=/usr/include/9libs \
	econf
}

src_install() {
	default

	insinto /usr/share/${PN}
	doins "${S}"/misc/*
}
