# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN=${PN%-*}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Jolly Good Fork of ProSystem"
HOMEPAGE="https://gitlab.com/jgemu/prosystem"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/jgemu/${MY_PN}.git"
else
	SRC_URI="https://gitlab.com/jgemu/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD GPL-2+"
SLOT="1"

DEPEND="
	media-libs/jg:1=
"
RDEPEND="
	${DEPEND}
	games-emulation/jgrf
"
BDEPEND="
	virtual/pkgconfig
"

src_compile() {
	emake CC="$(tc-getCC)" PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}
