# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="TkPasMan-${PV}"

DESCRIPTION="Useful and reliable personal password manager, written in Tcl/Tk"
HOMEPAGE="https://wbsoft.home.xs4all.nl/linux/tkpasman.html"
SRC_URI="https://wbsoft.home.xs4all.nl/linux/projects/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="ssl"

DEPEND="
	>=dev-lang/tcl-8.3:0=
	>=dev-lang/tk-8.3:0="
RDEPEND="${DEPEND}
	ssl? ( dev-libs/openssl:0= )
	"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2a-gentoo.patch
)

src_prepare() {
	default

	if use ssl; then
		sed -i "s:^USE_OPENSSL=true:USE_OPENSSL=false:g" config || die
	fi
}

src_install() {
	dobin ${PN}
	dodoc README ChangeLog TODO WARNING INSTALL
}
