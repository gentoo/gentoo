# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="GNAT Component Collection Core packages"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0819dfc7a447df26c27a99
	-> ${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnat_2016 gnat_2017 +gnat_2018 gnat_2019 +shared static-libs static-pic"

RDEPEND="
	dev-ada/libgpr[gnat_2016(-)?,gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?]
	dev-ada/libgpr[shared?,static-libs?,static-pic?]
	!dev-ada/gnatcoll"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2016(-)?,gnat_2017(-)?,gnat_2018(-)?]
	dev-ada/gprbuild[gnat_2019(-)?]"

REQUIRED_USE="^^ ( gnat_2016 gnat_2017 gnat_2018 gnat_2019 )"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	if use gnat_2016; then
		GCC_PV=4.9.4
	elif use gnat_2017; then
		GCC_PV=6.3.0
	elif use gnat_2018; then
		GCC_PV=7.3.1
	else
		GCC_PV=8.3.1
	fi
	default
	sed -i \
		-e "s:@GNATLS@:${CHOST}-gnatls-${GCC_PV}:g" \
		src/gnatcoll-projects.ads \
		|| die
}

src_configure() {
	emake prefix="${D}usr" PROCESSORS=$(makeopts_jobs) setup
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
