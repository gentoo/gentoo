# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

MY_PN="${PN/-bin/}"
DESCRIPTION="Blood remake"
HOMEPAGE="https://www.transfusion-game.com/"
SRC_URI="mirror://sourceforge/blood/${MY_PN}-1.0-linux.i386.zip
	mirror://sourceforge/blood/${MY_PN}-patch-${PV}-linux.i386.zip
	mirror://gentoo/${MY_PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND="sys-libs/glibc"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_PN}"

dir="/opt/${MY_PN}"
Ddir="${D}/${dir}"

src_install() {
	# install everything that looks anything like docs...
	dodoc ${MY_PN}/doc/*.txt ${MY_PN}/*txt qw/*txt
	HTML_DOCS="${MY_PN}/doc/*.html" einstalldocs

	#...then mass copy everything to the install dir...
	dodir "${dir}"
	cp -R * "${Ddir}" || die

	# ...and remove the docs since we don't need them installed twice.
	rm -rf \
		"${Ddir}"/${MY_PN}/doc \
		"${Ddir}"/qw/*txt \
		"${Ddir}"/${MY_PN}/*txt

	doicon "${DISTDIR}"/${MY_PN}.png
	make_wrapper ${MY_PN} ./${MY_PN}-glx "${dir}" "${dir}"
	make_desktop_entry ${MY_PN} "Transfusion" ${MY_PN}
}
