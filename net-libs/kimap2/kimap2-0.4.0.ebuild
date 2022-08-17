# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.60.0
QTMIN=5.12.3

DESCRIPTION="Library for interacting with IMAP servers - successor of kimap"
HOMEPAGE="https://api.kde.org/kdepim/kimap2/html/"
SRC_URI="https://invent.kde.org/pim/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="5"
KEYWORDS="~amd64"
S=${WORKDIR}/${PN}-v${PV}

DEPEND="
	dev-libs/cyrus-sasl:2
	>=dev-qt/qtnetwork-${QTMIN}:5[ssl]
	>=kde-apps/kmime-19.04.3:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
"
RDEPEND="${DEPEND}"

RESTRICT+=" test"
