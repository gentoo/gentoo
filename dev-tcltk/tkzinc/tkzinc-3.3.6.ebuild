# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A Tk widget library"
HOMEPAGE="http://www.tkzinc.org"
SRC_URI="http://www.tkzinc.org/Packages/Tkzinc-${PV}plus.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc threads"

DEPEND="
	dev-lang/tk:=
	media-libs/glew:=
	virtual/opengl
	doc? ( virtual/latex-base )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Tkzinc-${PV//.}+"

PATCHES=(
	"${FILESDIR}"/${PV}-ldflags.patch
	"${FILESDIR}"/${PN}-3.3.4-latex.patch
	)

HTML_DOCS='doc/*png doc/*html doc/*css'

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--enable-gl=damage \
		$(use_enable debug symbols) \
		$(use_enable threads)
}

src_compile() {
	default
	if use doc; then
		VARTEXFONTS="${T}"/fonts emake pdf
	fi
}

src_install() {
	default
	use doc && dodoc doc/refman.pdf
}

src_test() {
	emake test
}
