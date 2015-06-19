# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libiscsi/libiscsi-9999.ebuild,v 1.3 2013/03/23 14:42:31 ryao Exp $

EAPI=5

AUTOTOOLS_AUTORECONF="1"
inherit autotools-utils

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/sahlberg/libiscsi.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/sahlberg/libiscsi/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="iscsi client library and utilities"
HOMEPAGE="https://github.com/sahlberg/libiscsi"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
