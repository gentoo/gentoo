# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

DESCRIPTION="A Tk widget library"
HOMEPAGE="http://www.tkzinc.org"
SRC_URI="http://www.tkzinc.org/Packages/Tkzinc-${PV}plus.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="debug doc threads"

DEPEND="
	dev-lang/tk
	media-libs/glew
	virtual/opengl
	doc? ( virtual/latex-base )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Tkzinc-${PV//.}+"

PATCHES=(
	"${FILESDIR}"/${PV}-ldflags.patch
	"${FILESDIR}"/${PN}-3.3.4-latex.patch
	)

AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=( BUGS )

src_configure() {
	local myeconfargs=(
		--enable-shared
		--enable-gl=damage
		$(use_enable debug symbols)
		$(use_enable threads)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use doc && emake pdf
}

src_install() {
	autotools-utils_src_install

	dohtml -r doc/*
	use doc && dodoc doc/refman.pdf
}
