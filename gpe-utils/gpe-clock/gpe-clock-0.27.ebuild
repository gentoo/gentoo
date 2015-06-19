# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-utils/gpe-clock/gpe-clock-0.27.ebuild,v 1.1 2010/02/25 18:09:30 miknix Exp $

GPE_TARBALL_SUFFIX="gz"
GPE_MIRROR="http://gpe.linuxtogo.org/download/source"
inherit eutils gpe

DESCRIPTION="The GPE panel clock"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"

# When gpe-conf goes into portage, we need to add a RDEPEND on it here.
RDEPEND="gpe-base/libgpewidget gpe-base/libgpelaunch gpe-base/libschedule"
IUSE="${IUSE}"
