# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libmediawiki/libmediawiki-4.10.0.ebuild,v 1.1 2015/05/19 21:51:59 dilfridge Exp $

EAPI=5

MY_PV="${PV/_/-}"
MY_P="digikam-${MY_PV}"

KDE_MINIMAL="4.10"
inherit kde4-base

DESCRIPTION="KDE C++ interface for MediaWiki based web service as wikipedia.org"
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://kde/stable/digikam/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

S=${WORKDIR}/${MY_P}/extra/${PN}
