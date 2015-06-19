# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kqtquickcharts/kqtquickcharts-4.14.3.ebuild,v 1.1 2015/06/04 18:44:46 kensington Exp $

EAPI=5

DECLARATIVE_REQUIRED="always"
inherit kde4-base

DESCRIPTION="Qt Quick 1 plugin for beautiful and interactive charts"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="$(add_kdeapps_dep plasma-runtime)"
