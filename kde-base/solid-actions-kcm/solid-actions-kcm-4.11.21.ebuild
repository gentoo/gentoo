# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/solid-actions-kcm/solid-actions-kcm-4.11.21.ebuild,v 1.1 2015/07/02 13:23:00 mrueg Exp $

EAPI=5

KMNAME="kde-workspace"
CPPUNIT_REQUIRED="test"
inherit kde4-meta

DESCRIPTION="KDE control module for Solid actions"
HOMEPAGE="http://solid.kde.org"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep solid-runtime)
	!kde-base/solid:4
"
