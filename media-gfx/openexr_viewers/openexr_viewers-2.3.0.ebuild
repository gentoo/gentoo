# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="OpenEXR Viewers"
HOMEPAGE="http://openexr.com/"
SRC_URI="https://github.com/openexr/openexr/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="cg"

RDEPEND="
	~media-libs/ilmbase-${PV}:=
	~media-libs/openexr-${PV}:=
	virtual/opengl
	x11-libs/fltk:1[opengl]
	cg? ( media-gfx/nvidia-cg-toolkit )
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( ChangeLog README.md )

PATCHES=(
	"${FILESDIR}/${P}-fix-configure.patch"
	"${FILESDIR}/${P}-fix-cg-libdir.patch"
)

src_prepare() {
	default
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-openexrctltest
		--with-fltk-config="/usr/bin/fltk-config"
	)

	if use cg; then
		myeconfargs+=(
			--enable-cg
			--with-cg-prefix="/opt/nvidia-cg-toolkit"
		)
		append-ldflags "$(no-as-needed)" # binary-only libCg is not properly linked
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF}/pdf \
		install

	einstalldocs
}
