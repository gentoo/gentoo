# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [ "${PV%9999}" != "${PV}" ] ; then
	SCM=mercurial
	EHG_REPO_URI="http://hg.openttdcoop.org/${PN}"
fi

inherit toolchain-funcs ${SCM}

DESCRIPTION="A suite of programs to modify openttd/Transport Tycoon Deluxe's GRF files"
HOMEPAGE="https://dev.openttdcoop.org/projects/grfcodec"
[[ -z ${SCM} ]] && SRC_URI="https://binaries.openttd.org/extra/${PN}/${PV}/${P}-source.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="media-libs/libpng:0"
DEPEND="
	${RDEPEND}
	!games-util/nforenum
	dev-lang/perl
	dev-libs/boost
"

PATCHES=("${FILESDIR}/${PN}-6.0.6-gcc10.patch")

src_prepare() {
	default

	# Set up Makefile.local so that we respect CXXFLAGS/LDFLAGS
	cat > Makefile.local <<-__EOF__
		CXX=$(tc-getCXX)
		BOOST_INCLUDE=/usr/include
		CXXFLAGS=${CXXFLAGS}
		LDOPT=${LDFLAGS}
		UPX=
		V=1
		FLAGS=
		EXE=
	__EOF__
	sed -i -e 's/-O2//g' Makefile || die
}

src_install() {
	dobin grfcodec grfid grfstrip nforenum
	doman docs/*.1
	dodoc changelog.txt docs/*.txt
}
