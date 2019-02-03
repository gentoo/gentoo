# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Library for interacting with IMAP servers - successor of kimap"
SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcoreaddons)
	$(add_kdeapps_dep kmime)
	$(add_qt_dep qtnetwork 'ssl')
	dev-libs/cyrus-sasl:2
"
RDEPEND="${DEPEND}"

RESTRICT="test"
