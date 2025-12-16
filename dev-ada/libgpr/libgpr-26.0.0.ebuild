# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_{15..16} )
inherit ada multiprocessing

MYPN=gprbuild
MYP=${MYPN}-${PV}

DESCRIPTION="Ada library to handle GPRbuild project files"
HOMEPAGE="https://github.com/AdaCore/gprbuild"
SRC_URI="https://github.com/AdaCore/${MYPN}/archive/refs/tags/v${PV}.tar.gz
		-> ${MYP}.tar.gz"

S="${WORKDIR}"/${MYP}

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static-libs static-pic"

RDEPEND="dev-ada/xmlada:=[shared,static-libs?,static-pic?,${ADA_USEDEP}]"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"
REQUIRED_USE="${ADA_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}"/${PN}-2020-gentoo.patch
	"${FILESDIR}"/${P}-gcc16.patch
)

src_prepare() {
	default
	sed -i -e '/Library_Name/s|gpr|gnatgpr|' gpr/gpr.gpr || die
}

src_configure() {
	emake setup
}

src_compile() {
	build () {
		gprbuild -p -m -j$(makeopts_jobs) -XBUILD=production -v \
			-XLIBRARY_TYPE=$1 -XXMLADA_BUILD=$1 \
			gpr/gpr.gpr -cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
}

src_install() {
	emake prefix="${D}"/usr libgpr.install.shared
	use static-libs && emake prefix="${D}"/usr libgpr.install.static
	use static-pic  && emake prefix="${D}"/usr libgpr.install.static-pic
	rm -r "${D}"/usr/share/gpr/manifests || die
}
