# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-Spline/Math-Spline-0.10.0-r1.ebuild,v 1.1 2014/08/22 21:04:32 axs Exp $

EAPI=5

MODULE_AUTHOR=JARW
MODULE_VERSION=0.01
inherit perl-module

DESCRIPTION="Cubic Spline Interpolation of data"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/Math-Derivative"

# no tests
SRC_TEST="no"
PATCHES=( "${FILESDIR}"/0.01-pod.diff )
