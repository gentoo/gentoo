# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_202{0..1} )
inherit ada multiprocessing

MYPN=gprbuild
MYP=${MYPN}-${PV}

DESCRIPTION="Ada library to handle GPRbuild project files"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="https://github.com/AdaCore/${MYPN}/archive/refs/tags/v${PV}.tar.gz
		-> ${MYP}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+shared static-libs static-pic"

RDEPEND="dev-ada/xmlada[shared?,static-libs?,static-pic?,${ADA_USEDEP}]
	!net-libs/grpc"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"
REQUIRED_USE="${ADA_REQUIRED_USE}
	|| ( shared static-libs static-pic )"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${PN}-2020-gentoo.patch )

src_configure() {
	emake setup
}

src_compile() {
	build () {
		gprbuild -p -m -j$(makeopts_jobs) -XBUILD=production -v \
			-XLIBRARY_TYPE=$1 -XXMLADA_BUILD=$1 \
			gpr/gpr.gpr -cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} || die
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
}

src_install() {
	if use static-libs; then
		emake prefix="${D}"/usr libgpr.install.static
	fi
	for kind in shared static-pic; do
		if use ${kind}; then
			emake prefix="${D}"/usr libgpr.install.${kind}
		fi
	done
	rm -r "${D}"/usr/share/gpr/manifests || die
	einstalldocs
}
