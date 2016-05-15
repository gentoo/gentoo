# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [ "${PV%9999}" != "${PV}" ] ; then
	SCM=mercurial
	EHG_REPO_URI="http://hg.openttdcoop.org/${PN}"
fi

inherit toolchain-funcs ${SCM}

DESCRIPTION="A suite of programs to modify openttd/Transport Tycoon Deluxe's GRF files"
HOMEPAGE="http://dev.openttdcoop.org/projects/grfcodec"
[[ -z ${SCM} ]] && SRC_URI="http://binaries.openttd.org/extra/${PN}/${PV}/${P}-source.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

[[ -n ${SCM} ]] && S=${WORKDIR}/${PN}

RDEPEND="media-libs/libpng:0"
DEPEND="${RDEPEND}
	!games-util/nforenum
	dev-lang/perl
	dev-libs/boost"

src_prepare() {
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
