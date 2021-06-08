# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="System Tray Icon Support for Tk on X11"
HOMEPAGE="https://code.google.com/p/tktray/"
SRC_URI="https://tktray.googlecode.com/files/${PN}${PV}.tar.gz"
S="${WORKDIR}/${PN}${PV}"

LICENSE="tcltk"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="debug threads"

# tests need actual X server with user interaction, bug #284919
RESTRICT="test"

DEPEND="
	>=dev-lang/tcl-8.4:0=
	>=dev-lang/tk-8.4:0=
	x11-libs/libXext"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/1.1-ldflags.patch )

src_configure() {
	source /usr/lib/tclConfig.sh
	CPPFLAGS="-I${TCL_SRC_DIR}/generic ${CPPFLAGS}" \
	econf \
		$(use_enable debug symbols) \
		$(use_enable threads)
}
