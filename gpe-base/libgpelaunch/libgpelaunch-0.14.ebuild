# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-base/libgpelaunch/libgpelaunch-0.14.ebuild,v 1.2 2013/01/26 23:34:03 miknix Exp $

GPE_TARBALL_SUFFIX="bz2"

inherit gpe

DESCRIPTION="GPE helper library for launching programs"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE="${IUSE}"
GPE_DOCS=""

RDEPEND="${RDEPEND}
	>=gpe-base/libgpewidget-0.102
	x11-libs/startup-notification"
DEPEND="${DEPEND} ${RDEPEND}"
