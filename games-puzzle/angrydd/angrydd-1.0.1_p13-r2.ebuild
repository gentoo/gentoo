# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit desktop python-single-r1

DESCRIPTION="Angry, Drunken Dwarves, a falling blocks game similar to Puzzle Fighter"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://gentoo/${P/_p*}.tar.gz
	mirror://debian/pool/main/${P::1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz"
S="${WORKDIR}/${P/_p*}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pygame[${PYTHON_USEDEP}]')
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[vorbis]"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${WORKDIR}"/debian/patches
)

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr/share TO=${PN} install

	dosym -r /usr/share/${PN}/${PN}.py /usr/bin/${PN}
	doman angrydd.6
	einstalldocs

	python_fix_shebang "${ED}"/usr/share/${PN}
	python_optimize "${ED}"/usr/share/${PN}

	doicon ${PN}.png
	make_desktop_entry ${PN} "Angry, Drunken Dwarves"

	rm -r "${ED}"/usr/share/{games,share} || die
}
