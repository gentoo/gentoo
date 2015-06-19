# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/minlog/minlog-1.2.ebuild,v 1.3 2014/01/25 10:20:08 radhermit Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Minimal overhead Java logging"
HOMEPAGE="https://github.com/EsotericSoftware/minlog/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

S="${WORKDIR}/${PN}"
