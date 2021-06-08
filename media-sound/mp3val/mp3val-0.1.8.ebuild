# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit edos2unix

DESCRIPTION="Validate and fix MPEG audio files"
HOMEPAGE="http://mp3val.sourceforge.net/"
SRC_URI="mirror://sourceforge/mp3val/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}/${P}-open.patch"
)

src_prepare() {
	edos2unix "${S}"/{*.{cpp,h},Makefile*}
	chmod a-x "${S}"/*
	sed -i -e '/^C.*FLAGS.*=/d' "${S}"/Makefile.linux
	default
}

src_compile() {
	emake -f Makefile.linux
}

src_install() {
	dobin mp3val
	dohtml manual.html
	dodoc changelog.txt
}
