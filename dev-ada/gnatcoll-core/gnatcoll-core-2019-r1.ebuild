# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ADA_COMPAT=( gnat_201{6,7,8,9} )
inherit ada multiprocessing

MYP=${P}-20190515-24AD8

DESCRIPTION="GNAT Component Collection Core packages"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf8ae231e87a8f1d425052
	-> ${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+shared static-libs static-pic"

RDEPEND="
	dev-ada/libgpr[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	!dev-ada/gnatcoll"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${PN}-2018-gentoo.patch )

src_prepare() {
	default
	sed -i \
		-e "s:@GNATLS@:${GNATLS}:g" \
		src/gnatcoll-projects.ads \
		|| die
}

src_configure() {
	emake prefix="${D}"/usr PROCESSORS=$(makeopts_jobs) setup
}

src_compile() {
	build () {
		gprbuild -p -m -j$(makeopts_jobs) \
			-XBUILD=PROD -v -XGNATCOLL_VERSION=${PV} \
			-XLIBRARY_TYPE=$1 -XXMLADA_BUILD=$* -XGPR_BUILD=$1 \
			gnatcoll.gpr -cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} || die
	}
	if use shared; then
		build relocatable
	fi
	if use static-pic; then
		build static-pic
	fi
	if use static-libs; then
		build static
	fi
}

src_install() {
	if use shared; then
		emake install-relocatable
	fi
	if use static-pic; then
		emake install-static-pic
	fi
	if use static-libs; then
		emake install-static
	fi
	rm -r "${D}"/usr/share/gpr/manifests || die
	einstalldocs
}
