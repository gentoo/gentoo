# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

MY_PN=${PN%-*}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Jolly Good Port of Mednafen"
HOMEPAGE="https://gitlab.com/jgemu/mednafen"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/jgemu/${MY_PN}.git"
else
	SRC_URI="https://gitlab.com/jgemu/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="BSD GPL-2 GPL-2+ LGPL-2.1+ ZLIB"
SLOT="1"

DEPEND="
	app-arch/zstd
	dev-libs/lzo:2
	>=dev-libs/trio-1.17
	media-libs/flac
	media-libs/jg:1=
	sys-libs/zlib:=[minizip]
"
RDEPEND="
	${DEPEND}
	games-emulation/jgrf
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	cd jollygood/conf || die
	eautoreconf
}

src_configure() {
	cd jollygood/conf || die
	econf
}

src_compile() {
	emake -C jollygood \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		USE_EXTERNAL_TRIO=1
}

src_install() {
	emake -C jollygood install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		USE_EXTERNAL_TRIO=1
}
