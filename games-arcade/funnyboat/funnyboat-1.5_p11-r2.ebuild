# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit desktop python-single-r1 wrapper

DESCRIPTION="Side scrolling shooter game starring a steamboat on the sea"
HOMEPAGE="http://funnyboat.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P/_p*}-src.zip
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz"
S="${WORKDIR}/${PN}"

LICENSE="BitstreamVera GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pygame[${PYTHON_USEDEP}]')
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[vorbis]"
BDEPEND="
	${PYTHON_DEPS}
	app-arch/unzip"

PATCHES=(
	 "${WORKDIR}"/debian/patches
)

src_prepare() {
	# Drop Debian specific patch
	rm "${WORKDIR}"/debian/patches/use_debian_vera_ttf.patch || die

	default
}

src_install() {
	insinto /usr/share/${PN}
	doins -r data *.py

	python_optimize "${ED}"/usr/share/${PN}

	einstalldocs

	make_wrapper ${PN} "${EPYTHON} main.py" /usr/share/${PN}

	newicon data/titanic.png ${PN}.png
	make_desktop_entry ${PN} "Trip on the Funny Boat"
}
