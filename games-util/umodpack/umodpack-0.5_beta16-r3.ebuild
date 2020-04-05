# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module toolchain-funcs

MY_P="${P/_beta/b}"
DESCRIPTION="Portable (un)packer for Unreal Tournament's Umod files"
HOMEPAGE="http://www.oldunreal.com/wiki/index.php?title=UmodPack"
SRC_URI="mirror://gentoo/${MY_P}-allinone.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/perl-IO-Compress
	dev-perl/Archive-Zip
	dev-perl/Tie-IxHash"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
PATCHES=( "${FILESDIR}"/${PN}-fixes.patch )
DIST_TEST="do"

src_prepare() {
	default

	# Remove bundled Perl modules.
	rm -rf {Archive-Zip,Compress-Zlib,Tie-IxHash,Tk}* || die
}

src_compile() {
	perl-module_src_compile

	cd umr-* || die
	emake DEBUG=0 CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_test() {
	local line
	perl-module_src_test | while read line; do
		cat <<< "${line}"
		[[ ${line} =~ ^not\ ok\ [0-9] ]] && die "test failed"
	done
}

src_install() {
	perl-module_src_install

	cd umr-* || die
	dobin umr
	newdoc README README-umr
	newdoc TODO TODO-umr
}
