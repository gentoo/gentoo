# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper

DESCRIPTION="Third-person classic magical action-adventure game"
HOMEPAGE="http://www.lokigames.com/products/heretic2/
	http://www.hereticii.com/"
SRC_URI="mirror://lokigames/loki_demos/${PN}.run"
S="${WORKDIR}"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="strip mirror bindist"

RDEPEND="
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
"
BDEPEND="games-util/loki_patch"

dir=opt/${PN}
QA_PREBUILT="${dir}/*"
QA_TEXTRELS="opt/heretic2-demo/ref_glx.so"

src_install() {
	ABI=x86

	local demo="data/demos/heretic2_demo"
	local exe="heretic2_demo.x86"

	loki_patch patch.dat data/ || die

	# Remove bad opengl library
	rm -r "${demo}/gl_drivers/" || die

	# Change to safe default of 800x600 and option of normal opengl driver
	sed -i \
		-e "s:fullscreen \"1\":fullscreen \"1\"\nset vid_mode \"4\":" \
		-e "s:libGL:/usr/$(get_libdir)/libGL:" \
		"${demo}"/base/default.cfg || die

	insinto ${dir}
	exeinto ${dir}
	doins -r "${demo}"/*
	doexe "${demo}/${exe}"

	make_wrapper ${PN} "./${exe}" "${dir}" "${dir}"
	newicon "${demo}"/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Heretic 2 (Demo)" ${PN}
}
