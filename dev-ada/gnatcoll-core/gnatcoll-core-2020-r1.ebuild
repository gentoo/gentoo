# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ADA_COMPAT=( gnat_201{6,7,8,9} gnat_2020 )
inherit ada multiprocessing

MYP=${P}-20200429-19B7C

DESCRIPTION="GNAT Component Collection Core packages"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="https://community.download.adacore.com/v1/c94f2ac914cb305f6bef174329fa0b5003d84935?filename=${MYP}-src.tar.gz
	-> ${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+shared static-libs static-pic"

RDEPEND="
	>=dev-ada/libgpr-2020[${ADA_USEDEP},shared?,static-libs?,static-pic?]
"
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
	emake setup
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
		emake prefix="${D}"/usr install-relocatable
	fi
	if use static-pic; then
		emake prefix="${D}"/usr install-static-pic
	fi
	if use static-libs; then
		emake prefix="${D}"/usr install-static
	fi
	rm -r "${D}"/usr/share/gpr/manifests || die
	einstalldocs
}
