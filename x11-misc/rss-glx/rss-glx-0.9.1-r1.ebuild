# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils multilib

MY_P=${PN}_${PV}

DESCRIPTION="Really Slick OpenGL Screensavers for XScreenSaver"
HOMEPAGE="http://rss-glx.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~ppc64 ~sparc x86"
IUSE="+bzip2 openal quesoglc"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	>=media-libs/glew-1.5.1:=
	media-libs/mesa
	>=media-gfx/imagemagick-6.4:=
	>=x11-misc/xscreensaver-5.08-r2
	bzip2? ( app-arch/bzip2 )
	openal? ( >=media-libs/freealut-1.1.0-r1 )
	quesoglc? ( media-libs/quesoglc )
"
DEPEND="
	${RDEPEND}
	x11-proto/xextproto
	virtual/pkgconfig
	sys-apps/sed
"

DOCS="ChangeLog README*"
S=${WORKDIR}/${MY_P}
PATCHES=(
	"${FILESDIR}"/${P}-quesoglc.patch
	"${FILESDIR}"/${P}-asneeded.patch
	"${FILESDIR}"/${P}-imagemagick-7.patch
)

src_prepare() {
	default

	sed -i \
		-e '/CFLAGS=/s:-O2:${CFLAGS}:' \
		-e '/CXXFLAGS=/s:-O2:${CXXFLAGS}:' \
		-e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' \
		configure.in || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable bzip2) \
		$(use_enable openal sound) \
		$(use_with quesoglc) \
		--bindir=/usr/$(get_libdir)/misc/xscreensaver \
		--disable-dependency-tracking \
		--enable-shared \
		--with-configdir=/usr/share/xscreensaver/config
}

pkg_postinst() {
	local xssconf="${ROOT}usr/share/X11/app-defaults/XScreenSaver"

	if [ -f ${xssconf} ]; then
		sed -e '/*programs:/a\
		GL:       \"Cyclone\"  cyclone --root     \\n\\\
		GL:      \"Euphoria\"  euphoria --root    \\n\\\
		GL:    \"Fieldlines\"  fieldlines --root  \\n\\\
		GL:        \"Flocks\"  flocks --root      \\n\\\
		GL:          \"Flux\"  flux --root        \\n\\\
		GL:        \"Helios\"  helios --root      \\n\\\
		GL:    \"Hyperspace\"  hyperspace --root  \\n\\\
		GL:       \"Lattice\"  lattice --root     \\n\\\
		GL:        \"Plasma\"  plasma --root      \\n\\\
		GL:     \"Pixelcity\"  pixelcity --root   \\n\\\
		GL:     \"Skyrocket\"  skyrocket --root   \\n\\\
		GL:    \"Solarwinds\"  solarwinds --root  \\n\\\
		GL:     \"Colorfire\"  colorfire --root   \\n\\\
		GL:   \"Hufos Smoke\"  hufo_smoke --root  \\n\\\
		GL:  \"Hufos Tunnel\"  hufo_tunnel --root \\n\\\
		GL:    \"Sundancer2\"  sundancer2 --root  \\n\\\
		GL:          \"BioF\"  biof --root        \\n\\\
		GL:   \"BusySpheres\"  busyspheres --root \\n\\\
		GL:   \"SpirographX\"  spirographx --root \\n\\\
		GL:    \"MatrixView\"  matrixview --root  \\n\\\
		GL:        \"Lorenz\"  lorenz --root      \\n\\\
		GL:      \"Drempels\"  drempels --root    \\n\\\
		GL:      \"Feedback\"  feedback --root    \\n\\' \
			-i ${xssconf} || die
	fi
}

pkg_postrm() {
	local xssconf="${ROOT}usr/share/X11/app-defaults/XScreenSaver"

	if [ -f ${xssconf} ]; then
		sed \
			-e '/\"Cyclone\"  cyclone/d' \
			-e '/\"Euphoria\"  euphoria/d' \
			-e '/\"Fieldlines\"  fieldlines/d' \
			-e '/\"Flocks\"  flocks/d' \
			-e '/\"Flux\"  flux/d' \
			-e '/\"Helios\"  helios/d' \
			-e '/\"Hyperspace\"  hyperspace/d' \
			-e '/\"Lattice\"  lattice/d' \
			-e '/\"Plasma\"  plasma/d' \
			-e '/\"Pixelcity\"  pixelcity/d' \
			-e '/\"Skyrocket\"  skyrocket/d' \
			-e '/\"Solarwinds\"  solarwinds/d' \
			-e '/\"Colorfire\"  colorfire/d' \
			-e '/\"Hufos Smoke\"  hufo_smoke/d' \
			-e '/\"Hufos Tunnel\"  hufo_tunnel/d' \
			-e '/\"Sundancer2\"  sundancer2/d' \
			-e '/\"BioF\"  biof/d' \
			-e '/\"BusySpheres\"  busyspheres/d' \
			-e '/\"SpirographX\"  spirographx/d' \
			-e '/\"MatrixView\"  matrixview/d' \
			-e '/\"Lorenz\"  lorenz/d' \
			-e '/\"Drempels\"  drempels/d' \
			-e '/\"Feedback\"  feedback/d' \
			-i ${xssconf} || die
	fi
}
