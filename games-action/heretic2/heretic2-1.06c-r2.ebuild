# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cdrom desktop multilib unpacker wrapper

DESCRIPTION="Third-person classic magical action-adventure game"
HOMEPAGE="http://lokigames.com/products/heretic2/
	http://www.ravensoft.com/heretic2.html"
SRC_URI="mirror://lokigames/${PN}/${P/%?/b}-unified-x86.run
	mirror://lokigames/${PN}/${P}-unified-x86.run
	mirror://lokigames/${PN}/${PN}-maps-1.0.run"
S="${WORKDIR}"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip mirror bindist"

QA_TEXTRELS="opt/${PN}/base/*.so"

RDEPEND="
	virtual/opengl
	amd64? (
		>=virtual/opengl-7.0-r1[abi_x86_32(-)]
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
	)
	x86? (
		x11-libs/libX11
		x11-libs/libXext
	)
"
BDEPEND="games-util/loki_patch"

src_unpack() {
	cdrom_get_cds bin/x86/glibc-2.1/${PN}
	mkdir ${A} || die

	local f
	for f in * ; do
		cd "${S}"/${f} || die
		unpack_makeself ${f}
	done
}

src_install() {
	has_multilib_profile && ABI=x86

	local dir=/opt/${PN}

	cd "${CDROM_ROOT}" || die

	insinto ${dir}
	doins -r base help Manual.html README README.more

	exeinto ${dir}
	doexe bin/x86/glibc-2.1/${PN}

	make_wrapper ${PN} ./${PN} "${dir}" "${dir}"
	sed -i \
		-e 's/^exec /__GL_ExtensionStringVersion=17700 exec /' \
		"${ED}/usr/bin/${PN}" || die
	newicon icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Heretic II"

	cd "${ED}/${dir}" || die
	ln -s "${CDROM_ROOT}"/*.gz . || die
	unpack ./*.gz
	rm -f *.gz || die

	local d
	for d in "${S}"/* ; do
		pushd "${d}" > /dev/null || die
		loki_patch patch.dat "${ED}/${dir}" || die
		popd > /dev/null || die
	done

	rmdir gl_drivers || die

	sed -i \
		"128i set gl_driver \"/usr/$(get_libdir)/libGL.so\"" \
		base/default.cfg || die
}
