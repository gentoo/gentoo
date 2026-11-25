# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Metapackage for a fully configured cups printer setup"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="+browsed +foomatic foomatic-db-ppds pdf +postscript +poppler zeroconf"

RDEPEND="
	net-print/cups[zeroconf?]
	net-print/libppd[postscript?,poppler?]
	net-print/libcupsfilters[pdf?,poppler(+)?]
	net-print/cups-filters[foomatic?]

	browsed? ( net-print/cups-browsed )
	foomatic-db-ppds? ( net-print/foomatic-db-ppds )
	pdf? ( app-text/mupdf )
	postscript? ( >=app-text/ghostscript-gpl-9.09[cups] )
"
