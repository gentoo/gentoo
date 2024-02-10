# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Be a rampaging monster and destroy the city"
HOMEPAGE="https://www.evl.uic.edu/aej/AndyBattalion.html"
SRC_URI="
	https://www.evl.uic.edu/aej/BATTALION/${PN}${PV}.tar.bz2 -> ${PN}${PV}-r1.tar.bz2
	https://www.evl.uic.edu/aej/BATTALION/${PN}SUN4.tar.gz"
S="${WORKDIR}/${PN}${PV}"

LICENSE="battalion HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	virtual/glu
	virtual/opengl
	x11-libs/libX11"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-warning.patch
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	sed -e "/getenv.*DATADIR/s|= .*|= \"${EPREFIX}/usr/share/${PN}\";|" \
		-e "/getenv.*SCOREDIR/s|= .*|= \"${EPREFIX}/var/games\";|" \
		-i battalion.c || die

	sed '1s/1/6/' ../${PN}SUN4/${PN}.man > "${T}"/${PN}.6 || die

	# Only .raw sound files are used on Linux. The .au files are not needed.
	rm {SOUNDS,MUSIC}/*.au || die
}

src_compile() {
	tc-export CC PKG_CONFIG

	emake clean
	emake
}

src_install() {
	dobin ${PN}
	doman "${T}"/${PN}.6
	einstalldocs

	insinto /usr/share/${PN}
	doins -r DATA MUSIC SOUNDS TEXTURES ../${PN}SUN4/${PN}.data/${PN}.sho

	dodir /var/games
	> "${ED}"/var/games/${PN}_hiscore || die

	fowners :gamestat /usr/bin/${PN} /var/games/${PN}_hiscore
	fperms g+s /usr/bin/${PN}
	fperms 660 /var/games/${PN}_hiscore

	make_desktop_entry ${PN} ${PN^} applications-games
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Note that sound and music are not enabled by default,"
		elog "and require OSS support (/dev/dsp) to function."
	fi
}
