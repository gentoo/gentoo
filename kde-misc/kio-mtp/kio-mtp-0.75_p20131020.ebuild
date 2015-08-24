# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="MTP KIO-Client for KDE"
HOMEPAGE="https://projects.kde.org/projects/playground/base/kio-mtp"
COMMIT_ID="2063e757559edb20d744ac5200e8340f56de2afd"
SRC_URI="https://quickgit.kde.org/?p=kio-mtp.git&a=snapshot&h=${COMMIT_ID}&fmt=tgz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

S=${WORKDIR}/${PN}

DEPEND="
	>=media-libs/libmtp-1.1.3
"
RDEPEND="${DEPEND}"
