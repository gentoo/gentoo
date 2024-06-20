# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

if [[ "${PV}" == "9999" ]]
then
	EGIT_REPO_URI="https://github.com/adoptware/pinball"
	inherit git-r3
else
	MY_P="pinball-${PV}"
	SRC_URI="https://github.com/adoptware/pinball/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~ppc ~sparc ~x86"
fi

DESCRIPTION="SDL OpenGL pinball game"
HOMEPAGE="https://github.com/adoptware/pinball"

LICENSE="GPL-2 CC0-1.0"
SLOT="0"
IUSE="gles1-only"

DEPEND="
	media-libs/libsdl2[joystick,opengl,video]
	gles1-only? ( media-libs/libsdl2[gles1] )
	virtual/opengl
"
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"

PATCHES=(
	"${FILESDIR}/${P}_system_libtool.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable gles1-only gles)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	dosym pinball /usr/bin/emilia-pinball

	newicon data/pinball.xpm ${PN}.xpm
	make_desktop_entry emilia-pinball "Emilia pinball"

	fperms -R 660 /var/games/pinball
	fowners -R root:gamestat /usr/bin/pinball /var/games/pinball
	fperms g+s /usr/bin/pinball
}
