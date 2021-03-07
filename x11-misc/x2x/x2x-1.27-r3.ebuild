# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A utility to connect the Mouse and KeyBoard to another X"
HOMEPAGE="http://www.the-labs.com/X11/#x2x"
SRC_URI="http://ftp.digital.com/pub/Digital/SRC/x2x/${P}.tar.gz
	mirror://debian/pool/main/x/x2x/x2x_1.27-8.diff.gz
	mirror://gentoo/x2x_1.27-8-initvars.patch.gz
	mirror://gentoo/${P}-keymap.diff.gz"

LICENSE="x2x"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXext"
DEPEND="${RDEPEND}
	app-text/rman
	x11-base/xorg-proto
	x11-misc/imake"

PATCHES=(
	# Patch from Debian to add -north and -south, among other fixes
	"${WORKDIR}"/x2x_1.27-8.diff
	# Fix variable initialization in Debian patch
	"${WORKDIR}"/x2x_1.27-8-initvars.patch
	# Patch to fix bug #126939
	# AltGr does not work in x2x with different keymaps:
	"${WORKDIR}"/${P}-keymap.diff
)

src_prepare() {
	default

	# Revert part of debian patch messing with CFLAGS
	sed -i '/CFLAGS = -Wall/d' Imakefile || die
	# Man-page is packaged as x2x.1 but needs to be x2x.man for building
	mv x2x.1 x2x.man || die
}

src_configure() {
	xmkmf || die
}

src_compile() {
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	default
	newman x2x.man x2x.1
}
