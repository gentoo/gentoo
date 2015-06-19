# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/prekin/prekin-6.51.081122-r1.ebuild,v 1.4 2012/10/24 19:33:03 ulm Exp $

EAPI="2"

inherit toolchain-funcs eutils multilib

MY_P=${PN}.${PV}

DESCRIPTION="Prepares molecular kinemages (input files for Mage & KiNG) from PDB-format coordinate files"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/prekin.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/${PN}/${MY_P}.src.tgz"

LICENSE="richardson"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="X"

RDEPEND="x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXt
	X? ( >=x11-libs/motif-2.3:0 )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-Makefile.patch \
		"${FILESDIR}"/${PV}-overflow.patch
	sed  \
		-e 's:cc:$(CC):g' \
		-e "s:GENTOOLIBDIR:$(get_libdir):g" \
		"${S}"/Makefile.linux > Makefile || die
}

src_compile() {
	local mytarget

	if use X; then
		mytarget="${PN}"
	else
		mytarget="nogui"
	fi

	emake CC="$(tc-getCC)" ${mytarget} || die
}

src_install() {
	dobin "${S}"/prekin || die
}
