# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnustep-2

DESCRIPTION="Apple Addressbook work alike (standalone and for GNUMail)"
HOMEPAGE="http://gap.nongnu.org/addresses/"
SRC_URI="https://savannah.nongnu.org/download/gap/${P/a/A}.tar.gz"

S="${WORKDIR}/${P/a/A}"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=( "${FILESDIR}"/${PN}-0.4.7-as-needed.patch )
