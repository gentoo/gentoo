# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Rise of the Triad for Linux!"
HOMEPAGE="http://www.icculus.org/rott/"
SRC_URI="http://www.icculus.org/rott/releases/${P}.tar.gz
	demo? ( http://filesingularity.timedoctor.org/swdata.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="demo"

RDEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${P}/rott

src_prepare() {
	default

	sed -i \
		-e '/^CC =/d' \
		Makefile || die "sed failed"
	emake clean
}

src_compile() {
	emake -j1 \
		EXTRACFLAGS="${CFLAGS} -DDATADIR=\\\"/usr/share/${PN}/\\\"" \
		SHAREWARE=$(usex demo "1" "0")
}

src_install() {
	dobin rott
	dodoc ../doc/*.txt ../README
	doman ../doc/rott.6
	if use demo ; then
		cd "${WORKDIR}" || die
		insinto /usr/share/${PN}
		doins *.dmo huntbgin.* remote1.rts
	fi
}

pkg_postinst() {
	if ! use demo ; then
		elog "To play the full version, just copy the"
		elog "data files to /usr/share/${PN}/"
	fi
}
