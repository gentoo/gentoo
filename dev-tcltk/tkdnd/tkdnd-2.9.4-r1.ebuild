# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}-release-test-v${PV}

DESCRIPTION="Adds native drag & drop capabilities to tk toolkit"
HOMEPAGE="https://www.ellogon.org/petasis/index.php/tcltk-projects/tkdnd"
SRC_URI="https://github.com/petasis/tkdnd/archive/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug threads X"

DEPEND="
	dev-lang/tk:=
	x11-libs/libXcursor
"
RDEPEND=${DEPEND}

QA_CONFIG_IMPL_DECL_SKIP=(
	opendir64 readdir64 rewinddir64 closedir64 stat64 # used on AIX
)

S=${WORKDIR}/${PN}-${MY_P}

RESTRICT="test"

src_prepare() {
	sed \
		-e 's:-O2::g' \
		-e 's:-fomit-frame-pointer::g' \
		-e 's:-pipe::g' \
		-i configure tclconfig/tcl.m4 || die
	default
}

src_configure() {
	econf \
		$(use_with X x) \
		$(use_enable debug symbols) \
		$(use_enable threads)
}
