# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Time-Duration-Parse/Time-Duration-Parse-0.60.0-r1.ebuild,v 1.1 2014/08/26 16:04:11 axs Exp $

EAPI=5

MODULE_AUTHOR=MIYAGAWA
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Parse string that represents time duration"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Exporter-Lite
	dev-perl/Time-Duration"
DEPEND="${RDEPEND}"

SRC_TEST=do
