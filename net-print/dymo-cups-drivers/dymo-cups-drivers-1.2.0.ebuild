# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/dymo-cups-drivers/dymo-cups-drivers-1.2.0.ebuild,v 1.4 2012/07/31 14:13:16 flameeyes Exp $

EAPI=4

inherit eutils autotools

DESCRIPTION="Dymo SDK for LabelWriter/LabelManager printers"
HOMEPAGE="http://sites.dymo.com/DeveloperProgram/Pages/LW_SDK_Linux.aspx"
SRC_URI="http://download.dymo.com/Download%20Drivers/Linux/Download/${P}.tar.gz"

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
	epatch \
		"${FILESDIR}"/${P}+gcc-4.6.patch \
		"${FILESDIR}"/${P}-cxxflags.patch
	eautoreconf
}

DOCS=( AUTHORS README ChangeLog docs/SAMPLES )

src_install() {
	default

	insinto /usr/share/doc/${PF}
	doins docs/*.{txt,rtf,ps,png}
}
