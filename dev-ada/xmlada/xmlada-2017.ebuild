# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="Set of modules that provide a simple manipulation of XML streams"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591aeb88c7a4473fcbb154f8 ->
	${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+shared static static-pic"
REQUIRED_USE="|| ( shared static static-pic )"

RDEPEND="dev-lang/gnat-gpl:="
DEPEND="${RDEPEND}
	dev-ada/gprbuild"

S="${WORKDIR}"/${MYP}-src

src_configure () {
	econf --prefix="${D}"/usr
}

src_compile () {
	if use shared; then
		gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=relocatable \
			-XBUILD=Production -XPROCESSORS=$(makeopts_jobs) xmlada.gpr \
			-cargs ${ADAFLAGS}
	fi
	for kind in static static-pic; do
		if use ${kind}; then
			gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=${kind} \
				-XBUILD=Production -XPROCESSORS=$(makeopts_jobs) xmlada.gpr \
				-cargs ${ADAFLAGS}
		fi
	done
}

src_install () {
	for kind in shared static static-pic; do
		if use ${kind}; then
			emake PROCESSORS=$(makeopts_jobs) install-${kind}
		fi
	done
	einstalldocs
	dodoc xmlada-roadmap.txt
	rm "${D}"/usr/share/doc/${PN}/.buildinfo || die
}
