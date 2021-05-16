# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper

DESCRIPTION="Anglo-Saxon medieval army battles and resource management"
HOMEPAGE="http://www.linuxgamepublishing.com/info.php?id=knights"
# Unversioned upstream filename
SRC_URI="mirror://gentoo/${P}.run"
S="${WORKDIR}"

LICENSE="knights-demo"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

# Deps for the .dynamic binary which we don't support but install anyway
# TODO: wants gtk-1.2?!
# TODO: wants libgrapple?
DYNAMIC_DEPS="
	dev-libs/glib
	media-libs/libogg
	media-libs/libsdl
	media-libs/libvorbis
	media-libs/sdl-mixer
	media-libs/smpeg
	sys-libs/zlib
"
RDEPEND="
	sys-libs/glibc
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXau-1.0.7-r1[abi_x86_32(-)]
	>=x11-libs/libXdmcp-1.1.1-r1[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
	>=x11-libs/libXi-1.7.2[abi_x86_32(-)]
"

# RDEPEND+=" ${DYNAMIC_DEPS}"

QA_FLAGS_IGNORED="
	opt/knights-demo/knights-demo.dynamic
	opt/knights-demo/knights-demo
"

src_unpack() {
	unpack_makeself ${P}.run
	mv -f data{,-temp} || die
	unpack ./data-temp/data.tar.gz
	rm -rf data-temp lgp_* setup* || die
}

src_install() {
	local dir=/opt/${PN}

	exeinto "${dir}"
	doexe bin/Linux/x86/${PN}{,.dynamic}

	insinto "${dir}"
	doins -r data
	doins EULA icon.xpm README{,.licenses}

	# We don't support the dynamic version, even though we install it.
	make_wrapper ${PN} ./${PN} "${dir}" "${dir}"
	newicon icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Knights and Merchants (Demo)" ${PN}
}
