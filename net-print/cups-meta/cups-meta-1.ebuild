# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Metapackage for a fully configured cups printer setup"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="metapackage"
SLOT="0"
IUSE="+browsed +foomatic pdf +postscript +poppler zeroconf"
KEYWORDS="~amd64 ~arm64 ~loong"

RDEPEND="
	net-print/cups[zeroconf?]
	net-print/libppd[postscript?,poppler?]
	net-print/libcupsfilters[pdf?,poppler?]
	net-print/cups-filters[foomatic?]

	browsed? ( net-print/cups-browsed )
	pdf? ( app-text/mupdf )
	postscript? ( >=app-text/ghostscript-gpl-9.09[cups] )
"
