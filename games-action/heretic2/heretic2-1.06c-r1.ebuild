# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/heretic2/heretic2-1.06c-r1.ebuild,v 1.4 2015/06/01 22:05:45 mr_bones_ Exp $

EAPI=5
inherit eutils unpacker cdrom multilib games

DESCRIPTION="Third-person classic magical action-adventure game"
HOMEPAGE="http://lokigames.com/products/heretic2/
	http://www.ravensoft.com/heretic2.html"
SRC_URI="mirror://lokigames/${PN}/${P/%?/b}-unified-x86.run
	mirror://lokigames/${PN}/${P}-unified-x86.run
	mirror://lokigames/${PN}/${PN}-maps-1.0.run"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="strip"
QA_TEXTRELS="${GAMES_PREFIX_OPT:1}/${PN}/base/*.so"

DEPEND="games-util/loki_patch"
RDEPEND="virtual/opengl
	amd64? (
		>=virtual/opengl-7.0-r1[abi_x86_32(-)]
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
	)
	x86? (
		x11-libs/libX11
		x11-libs/libXext
	)"

S=${WORKDIR}

src_unpack() {
	cdrom_get_cds bin/x86/glibc-2.1/${PN}
	mkdir ${A}

	local f
	for f in * ; do
		cd "${S}"/${f}
		unpack_makeself ${f}
	done
}

src_install() {
	has_multilib_profile && ABI=x86

	local dir=${GAMES_PREFIX_OPT}/${PN}

	cd "${CDROM_ROOT}"

	insinto "${dir}"
	doins -r base help Manual.html README README.more

	exeinto "${dir}"
	doexe bin/x86/glibc-2.1/${PN}

	games_make_wrapper ${PN} ./${PN} "${dir}" "${dir}"
	sed -i \
		-e 's/^exec /__GL_ExtensionStringVersion=17700 exec /' \
		"${D}/${GAMES_BINDIR}/${PN}" || die
	newicon icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Heretic II"

	cd "${D}/${dir}"
	ln -s "${CDROM_ROOT}"/*.gz .
	unpack ./*.gz
	rm -f *.gz

	local d
	for d in "${S}"/* ; do
		pushd "${d}" > /dev/null
		loki_patch patch.dat "${D}/${dir}" || die
		popd > /dev/null
	done

	rmdir gl_drivers
	sed -i \
		"128i set gl_driver \"/usr/$(get_libdir)/libGL.so\"" \
		base/default.cfg || die

	prepgamesdirs
}
