# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="GNAT Component Collection Core packages"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc +shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"

RDEPEND="
	~dev-ada/libgpr-${PV}:=[${ADA_USEDEP},shared?,static-libs?,static-pic?]
"
BDEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]
	doc? (
		dev-python/sphinx
		dev-python/sphinx-rtd-theme
		dev-tex/latexmk
		dev-texlive/texlive-latexextra
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-2018-gentoo.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default
	sed -i \
		-e "s:@GNATLS@:${GNATLS}:g" \
		src/gnatcoll-projects.ads \
		|| die
	sed -i \
		-e "s:@PF@:${PF}:g" \
		gnatcoll.gpr \
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
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
	use doc && emake -C docs latexpdf
}

src_install() {
	local GNATCOLL_VERSION=${PV}
	if use shared; then
		emake GNATCOLL_VERSION=${PV} prefix="${D}"/usr install-relocatable
	fi
	if use static-pic; then
		emake GNATCOLL_VERSION=${PV} prefix="${D}"/usr install-static-pic
	fi
	if use static-libs; then
		emake GNATCOLL_VERSION=${PV} prefix="${D}"/usr install-static
	fi
	rm -r "${D}"/usr/share/gpr/manifests || die
	einstalldocs
}
