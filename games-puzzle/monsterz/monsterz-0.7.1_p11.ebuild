# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit desktop python-r1

DESCRIPTION="A little puzzle game, similar to the famous Bejeweled or Zookeeper"
HOMEPAGE="http://sam.zoy.org/projects/monsterz/"
SRC_URI="
	http://sam.zoy.org/projects/monsterz/${P/_p*}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
"

LICENSE="GPL-1+ LGPL-2+ WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygame[${PYTHON_USEDEP}]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]
"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}/${P/_p*}"

src_prepare() {
	default

	# Debian fixes
	for p in $(<"${WORKDIR}"/debian/patches/series) ; do
		eapply -p1 "${WORKDIR}/debian/patches/${p}"
	done

	eapply "${FILESDIR}"/${PN}-0.7.1-gentoo-r1.patch
	sed -i \
        	-e "s:GENTOO_DATADIR:/usr/share/${PN}:" \
		monsterz.py || die "sed failed"

	rm Makefile || die
}

src_install() {
	insinto /usr/share/${PN}
	doins -r graphics sound
	newbin monsterz.py ${PN}
	newicon graphics/icon.png ${PN}.png
	make_desktop_entry ${PN} Monsterz
	einstalldocs
	python_replicate_script "${ED}"/usr/bin/monsterz
}
