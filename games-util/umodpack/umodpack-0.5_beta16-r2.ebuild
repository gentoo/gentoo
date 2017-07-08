# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module toolchain-funcs

MY_P=${P/_beta/b}
DESCRIPTION="portable and useful [un]packer for Unreal Tournament's Umod files"
HOMEPAGE="http://www.oldunreal.com/wiki/index.php?title=UmodPack"
SRC_URI="mirror://gentoo/${MY_P}-allinone.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="tk"

DEPEND="virtual/perl-IO-Compress
	dev-perl/Archive-Zip
	dev-perl/Tie-IxHash
	tk? ( dev-perl/Tk )"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}
SRC_TEST="do parallel"

src_prepare() {
	# remove the stupid perl modules since we already installed em
	rm -rf {Archive-Zip,Compress-Zlib,Tie-IxHash,Tk}* || die
}

src_compile() {
	perl-module_src_compile

	cd umr-0.3 || die
	emake DEBUG=0 CFLAGS="${CFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	mydoc="Changes"
	perl-module_src_install
	dobin umod umr-0.3/umr
	if use tk ; then
		dobin xumod
	fi
}
