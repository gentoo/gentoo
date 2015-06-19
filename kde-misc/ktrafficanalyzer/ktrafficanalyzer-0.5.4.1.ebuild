# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/ktrafficanalyzer/ktrafficanalyzer-0.5.4.1.ebuild,v 1.4 2014/03/21 18:40:03 johu Exp $

EAPI=5

inherit kde4-base

MY_P=KTrafficAnalyzer-${PV}

DESCRIPTION="A network traffic visualizer"
HOMEPAGE="http://ktrafficanalyze.sourceforge.net/"
SRC_URI="mirror://sourceforge/ktrafficanalyze/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

S=${WORKDIR}/${MY_P}

DOCS=(CHANGELOG SSHUsage TODO)
