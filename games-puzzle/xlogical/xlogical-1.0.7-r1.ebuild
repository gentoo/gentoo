# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop edos2unix

MY_PV=$(ver_rs 2 '-')
MY_P=${PN}-${MY_PV}
DESCRIPTION="SDL logical clone"
HOMEPAGE="https://changeling.ixionstudios.com/xlogical/"
SRC_URI="https://changeling.ixionstudios.com/xlogical/downloads/${MY_P}.tar.bz2
	alt_gfx? ( https://changeling.ixionstudios.com/xlogical/downloads/${PN}_gfx.zip )"
S="${WORKDIR}"/${PN}-$(ver_cut 1-2)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alt_gfx"

DEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[jpeg]
	media-libs/sdl-mixer[mod]
"
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"
BDEPEND="alt_gfx? ( app-arch/unzip )"

PATCHES=(
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-gcc43.patch
)

src_unpack() {
	unpack ${MY_P}.tar.bz2

	if use alt_gfx ; then
		cd "${S}"/images || die
		unpack xlogical_gfx.zip
	fi
}

src_prepare() {
	sed -i '/^CXXFLAGS/d' Makefile.am || die

	edos2unix properties.h anim.h exception.h

	default

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	# localstatedir is only used for the score file
	# NOTE: Check on bumps!
	econf --localstatedir="/var/games"
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r ${PN}.{properties,levels} music sound images
	find "${ED}" -name "Makefile*" -exec rm -f '{}' + || die

	insinto /var/games/${PN}
	doins ${PN}.scores

	fowners root:gamestat /var/games/${PN}/${PN}.scores
	fperms 660 /var/games/${PN}/${PN}.scores
	fperms g+s /usr/bin/${PN}

	dodoc AUTHORS ChangeLog NEWS README TODO
	make_desktop_entry ${PN} "Xlogical"
}
