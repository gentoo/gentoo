# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="objs/doc"

inherit docs toolchain-funcs

MY_PN=${PN%-*}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Jolly Good Fork of bsnes"
HOMEPAGE="https://gitlab.com/jgemu/bsnes"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/jgemu/${MY_PN}.git"
else
	SRC_URI="https://gitlab.com/jgemu/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="
	ISC GPL-3+ LGPL-2.1+ MIT ZLIB
	examples? ( 0BSD )
"
SLOT="1"
IUSE="examples +jgmodule shared"
REQUIRED_USE="
	|| ( examples jgmodule shared )
	doc? ( shared )
"

DEPEND="
	media-libs/libsamplerate
	examples? ( media-libs/libsdl2[sound,video] )
	jgmodule? ( media-libs/jg:1= )
"
RDEPEND="
	${DEPEND}
	jgmodule? ( games-emulation/jgrf )
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local makeopts=(
		PREFIX="${EPREFIX}"/usr
		DISABLE_MODULE=$(usex jgmodule 0 1)
		ENABLE_EXAMPLE=$(usex examples 1 0)
		ENABLE_SHARED=$(usex shared 1 0)
	)
	export MY_MAKEOPTS="${makeopts[@]}"
}

src_compile() {
	local mymakeargs=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		${MY_MAKEOPTS}
	)
	emake "${mymakeargs[@]}"
	use doc && emake doxyfile
	docs_compile
}

src_install() {
	local mymakeargs=(
		DESTDIR="${D}"
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF}
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		${MY_MAKEOPTS}
	)
	emake install "${mymakeargs[@]}"
	use doc && einstalldocs
}
