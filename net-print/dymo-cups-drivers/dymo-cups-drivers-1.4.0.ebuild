# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils autotools

DESCRIPTION="Dymo SDK for LabelWriter/LabelManager printers"
HOMEPAGE="https://newellrubbermaid.secure.force.com/dymopkb"
SRC_URI="http://download.dymo.com/Download%20Drivers/Linux/Download/${P}.tar.gz"

S="${WORKDIR}/${P}.5"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

KEYWORDS="~amd64 ~x86"

RDEPEND="net-print/cups"
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )"

# tests fail but needs to be investigated
RESTRICT=test

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.2.0-cxxflags.patch
	epatch "${FILESDIR}"/port_to_newer_cups_headers.patch
	eautoreconf
}

DOCS=( AUTHORS README ChangeLog docs/SAMPLES )

src_install() {
	default

	insinto /usr/share/doc/${PF}
	doins docs/*.{txt,rtf,ps,png}
}
