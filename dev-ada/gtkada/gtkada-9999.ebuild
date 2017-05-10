# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multiprocessing git-r3

DESCRIPTION="A complete Ada graphical toolkit"
HOMEPAGE="http://libre.adacore.com//tools/gtkada/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+shared static"

RDEPEND="dev-lang/gnat-gpl
	dev-libs/atk
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}
	dev-ada/gprbuild"

EGIT_REPO_URI="https://github.com/AdaCore/gtkada.git"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

pkg_setup() {
	GCC=${ADA:-$(tc-getCC)}
	export GNATPREP="${GCC/gcc/gnatprep}"
	if [[ -z "$(type ${GNATPREP} 2>/dev/null)" ]] ; then
		eerror "You need a gcc compiler that provides the Ada Compiler:"
		eerror "1) use gcc-config to select the right compiler or"
		eerror "2) set ADA=gcc-4.9.4 in make.conf"
		die "ada compiler not available"
	fi
}

src_prepare() {
	default
	mv configure.{in,ac}
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static) \
		$(use_enable shared) \
		--without-GL
}

src_compile() {
	emake -j1 PROCESSORS=$(makeopts_jobs)
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	einstalldocs
}
