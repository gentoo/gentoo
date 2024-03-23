# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN=${PN%-*}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Jolly Good Fork of Gambatte"
HOMEPAGE="https://gitlab.com/jgemu/gambatte"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/jgemu/${MY_PN}.git"
else
	SRC_URI="https://gitlab.com/jgemu/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="
	GPL-2
	examples? ( 0BSD )
	jgmodule? ( BSD )
"
SLOT="1"
IUSE="examples +jgmodule shared"
REQUIRED_USE="|| ( examples jgmodule shared )"

DEPEND="
	examples? (
		media-libs/libsdl2[sound,video]
		media-libs/speexdsp
	)
	jgmodule? (
		media-libs/jg:1=
		media-libs/soxr
	)
"
RDEPEND="
	${DEPEND}
	jgmodule? ( games-emulation/jgrf )
"
BDEPEND="
	virtual/pkgconfig
"

pkg_setup() {
	local makeopts=(
		DISABLE_MODULE=$(usex jgmodule 0 1)
		ENABLE_EXAMPLE=$(usex examples 1 0)
		ENABLE_SHARED=$(usex shared 1 0)
	)
	export MY_MAKEOPTS="${makeopts[@]}"
}

src_compile() {
	local mymakeargs=(
		CXX="$(tc-getCXX)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		${MY_MAKEOPTS}
	)
	emake "${mymakeargs[@]}"
}

src_install() {
	local mymakeargs=(
		DESTDIR="${D}"
		PREFIX="${EPREFIX}"/usr
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF}
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		${MY_MAKEOPTS}
	)
	emake install "${mymakeargs[@]}"
}
