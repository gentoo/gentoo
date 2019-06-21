# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing

MYP=${P}-20190517-195C4
DESCRIPTION="Libadalang-based tools: gnatpp, gnatmetric and gnatstub"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf8f4e31e87a8f1d42509f ->
	${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 gnat_2017 gnat_2018 +gnat_2019"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-ada/libadalang[gnat_2016(-)?,gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?,static-libs]
	dev-ada/gprbuild[gnat_2016(-)?,gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?]"

S="${WORKDIR}"/${MYP}-src

src_compile() {
	gprbuild -v -k -XLIBRARY_TYPE=static -XXMLADA_BUILD=static \
		-XGNATCOLL_GMP_BUILD=static \
		-P src/build.gpr -p -j$(makeopts_jobs) || die
}

src_install() {
	dobin bin/gnatpp
	newbin bin/gnatmetric gnatmetric-tool
	newbin bin/gnatstub gnatstub-tool
	einstalldocs
}
