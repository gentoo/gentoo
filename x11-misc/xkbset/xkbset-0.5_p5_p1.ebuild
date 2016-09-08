# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils toolchain-funcs versionator

DEBIAN_P_MAJOR=$(get_version_component_range 3)
DEBIAN_P_MAJOR=${DEBIAN_P_MAJOR/p/}
DEBIAN_P_MINOR=$(get_version_component_range 4)
DEBIAN_P_MINOR=${DEBIAN_P_MINOR/p/}

DESCRIPTION="User preference utility for XKB extensions for X"
HOMEPAGE="http://www.math.missouri.edu/~stephen/software/"
SRC_URI="
	http://www.math.missouri.edu/~stephen/software/${PN}/${P/_p*/}.tar.gz
	mirror://debian/pool/main/x/${PN}/${PN}_${PV/_p*/}-${DEBIAN_P_MAJOR}.${DEBIAN_P_MINOR}.diff.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tk"

CDEPEND="
	x11-libs/libX11
"
DEPEND="
	${CDEPEND}
"
RDEPEND="
	${CDEPEND}
	tk? ( dev-perl/Tk )
"

S=${WORKDIR}/${P/_p*/}

PATCHES=(
	"${FILESDIR}"/${P/_p*/}-ldflags.patch
	"${WORKDIR}"/${PN}_${PV/_p*}-${DEBIAN_P_MAJOR}.${DEBIAN_P_MINOR}.diff
	"${WORKDIR}"/${P/_p*/}/debian/patches/02_clarify_errors.dpatch
)

src_compile() {
	emake CC=$(tc-getCC) INC_PATH= LIB_PATH=
}

src_install() {
	dobin xkbset
	use tk && dobin xkbset-gui
	doman xkbset.1
	dodoc README TODO
}
