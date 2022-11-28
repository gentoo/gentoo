# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ADA_COMPAT=( gnat_2021 )
inherit ada multiprocessing

MYP=${P}-${PV}0518-19ADF
ADAMIRROR=https://community.download.adacore.com/v1
ID=425b044d5cb112f096c7ac5ebbafb0d8e5297913

DESCRIPTION="GNAT Component Collection Core packages"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="${ADAMIRROR}/${ID}?filename=${MYP}-src.tar.gz -> ${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"

RDEPEND="
	>=dev-ada/libgpr-2021[${ADA_USEDEP},shared?,static-libs?,static-pic?]
"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

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
	dodir /usr/share/gnatdoc
	mv "${D}"/usr/share/doc/gnatcoll "${D}"/usr/share/gnatdoc/ || die
}
