# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

MY_P=gnat-gpl-2016-x86_64-linux-bin

DESCRIPTION="The GNAT Programming Studio"
HOMEPAGE="http://libre.adacore.com/tools/gps/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5739cefdc7a447658e0b016b -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-ada/gnatcoll[iconv,postgresql,projects,readline,sqlite]
	dev-ada/gprbuild[shared]
	dev-db/sqlite
	dev-lang/gnat-gpl
	dev-libs/atk
	dev-libs/glib
	dev-libs/gobject-introspection
	dev-libs/libffi
	media-libs/fontconfig
	media-libs/freetype
	sys-devel/llvm
	sys-devel/clang
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+
	x11-libs/pango
	x11-themes/adwaita-icon-theme
	x11-themes/hicolor-icon-theme"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	GCC=${ADA:-$(tc-getCC)}
	GNATLS="${GCC/gcc/gnatls}"
	GNAT="${GCC/gcc/gnat}"
	GNATMAKE="${GCC/gcc/gnatmake}"
	if [[ -z "$(type ${GNATLS} 2>/dev/null)" ]] ; then
		eerror "You need a gcc compiler that provides the Ada Compiler:"
		eerror "1) use gcc-config to select the right compiler or"
		eerror "2) set ADA=gcc-4.9.4 in make.conf"
		die "ada compiler not available"
	fi
}

src_compile() {
	:
}

src_install() {
	into /opt/${P}
	dobin bin/gps_exe
	dobin bin/gps_cli
	insinto /opt/${P}/share
	doins -r share/doc
	doins -r share/examples
	doins -r share/gpr
	doins -r share/gprconfig
	doins -r share/gps
	doins -r share/themes
	insinto /opt/${P}/lib/
	doins -r lib/python2.7
	dosym ../../../usr/bin/gnatinspect /opt/${P}/bin/gnatinspect
	dosym ../../../usr/bin/${GNATLS} /opt/${P}/bin/gnatls
	dosym ../../../usr/bin/${GNATMAKE} /opt/${P}/bin/gnatmake
	dosym ../../../usr/bin/${GNAT} /opt/${P}/bin/gnat
	dosym ../../opt/${P}/bin/gps_exe /usr/bin/gps
}
