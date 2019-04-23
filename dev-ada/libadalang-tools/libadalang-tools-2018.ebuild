# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYP=${PN}-gpl-${PV}
DESCRIPTION="Libadalang-based tools: gnatpp, gnatmetric and gnatstub"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0819dfc7a447df26c27a59 ->
	${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 gnat_2017 +gnat_2018"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-ada/libadalang[gnat_2016=,gnat_2017=,gnat_2018=,static-libs]"

S="${WORKDIR}"/${PN}-src

src_install() {
	dobin bin/gnatpp
	newbin bin/gnatmetric gnatmetric-tool
	newbin bin/gnatstub gnatstub-tool
	einstalldocs
}
