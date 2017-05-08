# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="Set of modules that provide a simple manipulation of XML streams"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/AdaCore/xmlada.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+shared static static-pic"
REQUIRED_USE="|| ( shared static static-pic )"

RDEPEND="dev-lang/gnat-gpl"
DEPEND="${RDEPEND}
	dev-ada/gprbuild"

PATCHES=( "${FILESDIR}"/${PN}-2016-gentoo.patch )

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
	mv "${D}"/usr/share/doc/${PN} "${D}"/usr/share/doc/${PF}/html || die
}
