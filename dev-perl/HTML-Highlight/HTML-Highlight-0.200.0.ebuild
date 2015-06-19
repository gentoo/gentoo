# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Highlight/HTML-Highlight-0.200.0.ebuild,v 1.1 2014/12/06 00:13:59 dilfridge Exp $

EAPI=5

MODULE_AUTHOR="TRIPIE"
MODULE_VERSION=0.20
inherit perl-module

DESCRIPTION="A module to highlight words or patterns in HTML documents"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"
PATCHES=( "${FILESDIR}"/fix-pod.patch )
