# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="Ada unit testing framework"
HOMEPAGE="http://libre.adacore.com/tools/aunit/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0819e0c7a447df26c27ab3
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 gnat_2017 +gnat_2018"

RDEPEND="gnat_2016? ( dev-lang/gnat-gpl:4.9.4 )
	gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )
	gnat_2018? ( dev-lang/gnat-gpl:7.3.1 )"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2016=,gnat_2017=,gnat_2018=]"

REQUIRED_USE="^^ ( gnat_2016 gnat_2017 gnat_2018 )"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${PN}-2016-gentoo.patch )

src_compile() {
	emake GPRBUILD="gprbuild -j$(makeopts_jobs) -v"
}

src_install() {
	emake INSTALL="${D}"usr install
	einstalldocs
	mv "${D}"usr/share/doc/${PN}/* "${D}"usr/share/doc/${PF}/ || die
	rmdir "${D}"usr/share/doc/${PN} || die
	mv "${D}"usr/share/examples/${PN} "${D}"usr/share/doc/${PF}/examples || die
	rmdir "${D}"usr/share/examples || die
	rm -r "${D}"/usr/share/gpr/manifests || die
}
