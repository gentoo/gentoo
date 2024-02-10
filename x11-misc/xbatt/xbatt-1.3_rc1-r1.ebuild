# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_PV=${PV/_rc/pr}

DESCRIPTION="Notebook battery indicator for X"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-$(ver_cut 1-2)"

LICENSE="xbatt"
SLOT="0"
KEYWORDS="amd64 ppc x86"
RDEPEND="
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libxkbfile
	x11-libs/libXpm"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.1-implicits.patch
	"${FILESDIR}"/${PN}-1.2.1-clang16.patch
)

src_configure() {
	append-cflags -std=gnu89 # old codebase, incompatible with c2x

	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		xbatt
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}
