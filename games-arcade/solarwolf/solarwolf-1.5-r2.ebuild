# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit desktop eutils python-r1

DESCRIPTION="Action/arcade recreation of SolarFox"
HOMEPAGE="http://www.pygame.org/shredwheat/solarwolf/"
SRC_URI="
	http://www.pygame.org/shredwheat/solarwolf/${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}+dfsg1-1.debian.tar.xz
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/pygame-1.5.6[${PYTHON_USEDEP}]
	media-libs/sdl-mixer[mod,vorbis]
"
DEPEND="${RDEPEND}"
BDEPEND=""

src_prepare() {
	default

	eapply -p1 "${WORKDIR}"/debian/patches/*.patch

	find . -name .xvpics -print0 | xargs -0 rm -fr
	gunzip dist/${PN}.6.gz || die #619948
}

src_install() {
	insinto /usr/share/${PN}
	doins -r code data *py
	make_wrapper ${PN} "python3 ./solarwolf.py" /usr/share/${PN}
	newicon data/ship-big.png ${PN}.png
	make_desktop_entry ${PN} SolarWolf
	einstalldocs
	doman dist/${PN}.6
}
