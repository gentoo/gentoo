# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# FIXME. What is linguas_jv, different Japanese translation?
KDE_LINGUAS="ar cs da de el en_GB es et fa fi fr gl he hr hu id is it ja kk ko
lt lv ms nb nl oc pl pt pt_BR ro ru sk sv tl tr uk zh_CN zh_TW"
KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="A frontend for sudo. Unlike kdesu, it uses directly sudo as backend"
HOMEPAGE="https://launchpad.net/kdesudo/"
SRC_URI="https://launchpad.net/${PN}/3.x/${PV}/+download/${P}.tar.gz"

LICENSE="FDL-1.2 GPL-2 LGPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	app-admin/sudo
"

DOCS=( AUTHORS ChangeLog README )
