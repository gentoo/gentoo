# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libkfbapi/libkfbapi-1.0.ebuild,v 1.7 2013/12/11 20:31:30 ago Exp $

EAPI=5

KDE_LINGUAS="ar be bs cs da de el en_GB eo es et fi fr ga gl hi hu it ja kk km
lt mai mr nb nds nl nn oc pa pl pt pt_BR ro ru sk sl sv tr ug uk zh_TW"
inherit kde4-base

DESCRIPTION="Library for accessing Facebook services based on KDE technology"
HOMEPAGE="https://projects.kde.org/projects/extragear/libs/libkfbapi"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepimlibs)
	dev-libs/libxslt
	dev-libs/qjson
"
RDEPEND="${DEPEND}"
