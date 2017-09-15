# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="Set of modules that provide a simple manipulation of XML streams"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/57399978c7a447658e0affc0 ->
	${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnat_2016 gnat_2017 +shared static static-pic"
REQUIRED_USE="|| ( shared static static-pic )
	^^ ( gnat_2016 gnat_2017 )"

RDEPEND="gnat_2016? ( dev-lang/gnat-gpl:4.9.4 )
	gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2016=,gnat_2017=]"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure () {
	econf --prefix="${D}"/usr
}

src_compile () {
	for kind in shared static static-pic; do
		if use ${kind}; then
			emake PROCESSORS=$(makeopts_jobs) ${kind}
		fi
	done
}

src_install () {
	for kind in shared static static-pic; do
		if use ${kind}; then
			emake PROCESSORS=$(makeopts_jobs) DESTDIR="${D}" install-${kind}
		fi
	done
	einstalldocs
	dodoc features-* known-problems-* xmlada-roadmap.txt
	rm "${D}"/usr/share/doc/${PN}/.buildinfo || die
}
