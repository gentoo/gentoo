# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs gnome2-utils eutils

DESCRIPTION="Planetarium for amauter astronomers"
HOMEPAGE="http://www.ap-i.net/skychart/"

MY_PV=${PV:0:4}-${PV:5:4}
DATA_PKG="data_jpleph.tgz
	catalog_gcvs.tgz
	catalog_idx.tgz
	catalog_tycho2.tgz
	catalog_wds.tgz
	catalog_gcm.tgz
	catalog_gpn.tgz
	catalog_lbn.tgz
	catalog_ngc.tgz
	catalog_ocl.tgz
	catalog_pgc.tgz
	pictures_sac.tgz"
SRC_URI="${DATA_SRC_URI}
	mirror://sourceforge/skychart/1-software/version_${PV:0:4}/skychart-${MY_PV}-src.tar.xz"
for i in ${DATA_PKG} ; do
	SRC_URI="${SRC_URI} mirror://sourceforge/skychart/4-source_data/${i}"
done
unset i

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# pascal
QA_FLAGS_IGNORED="usr/bin/cdcicon
	usr/bin/skychart
	usr/bin/varobs
	usr/bin/varobs_lpv_bulletin"

CDEPEND="x11-libs/gtk+:2
	x11-libs/libX11"
RDEPEND="${CDEPEND}
	x11-misc/xplanet"
DEPEND="${CDEPEND}
	>=dev-lang/lazarus-1.0.4
	>=dev-lang/fpc-2.6.0"

S=${WORKDIR}/${PN}-${MY_PV}-src

src_unpack() {
	unpack skychart-${MY_PV}-src.tar.xz

	local i
	for i in ${DATA_PKG} ; do
		mkdir ${i} || die
		cd ${i} || die
		unpack ${i}
		cd ..
	done
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-QA.patch
}

src_configure() {
	tc-export CC CXX

	./configure \
		fpcbin="/usr/bin" \
		fpc="/usr/lib/fpc/$(fpc -iV)/source" \
		lazarus="/usr/share/lazarus" \
		prefix="/usr"
}

src_compile() {
	# this is ugly, but the build system sux, so don't bother me
	UNITDIR="/usr/share/lazarus/components/printers:/usr/share/lazarus/components/printers/unix" \
	INCDIR="/usr/share/lazarus/components/printers/unix:/usr/share/lazarus/components/printers" \
		emake -j1
}

src_install() {
	# use build system install rules on version bump
	# to check for new files
	dobin varobs/{varobs,varobs_lpv_bulletin}
	dobin skychart/cdcicon
	newbin skychart/cdc skychart

	dolib.so skychart/library/plan404/libplan404.so
	dolib.so skychart/library/getdss/libgetdss.so
	dolib.so skychart/library/wcs/libcdcwcs.so

	insinto /usr/share
	doins -r system_integration/Linux/share/{applications,appdata,icons,pixmaps}

	dodoc system_integration/Linux/share/doc/skychart/changelog

	insinto /usr/share/skychart
	doins -r tools/{cat,data}
	for i in ${DATA_PKG} ; do
		cd "${WORKDIR}/${i}" || die
		doins -r .
	done
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
