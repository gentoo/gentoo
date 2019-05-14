# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DEBIAN_P=${PV#*_p}
DEBIAN_P=${DEBIAN_P/_p/.}

DESCRIPTION="User preference utility for XKB extensions for X"
HOMEPAGE="https://faculty.missouri.edu/~stephen/software/#xkbset"
SRC_URI="
	https://faculty.missouri.edu/~stephen/software/${PN}/${P/_p*/}.tar.gz
	mirror://debian/pool/main/x/${PN}/${PN}_${PV/_p*/}-${DEBIAN_P}.debian.tar.xz
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
	"${WORKDIR}"/debian/patches/02-clarify-errors.patch
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
