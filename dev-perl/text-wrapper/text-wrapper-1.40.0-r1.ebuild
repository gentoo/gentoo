# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/text-wrapper/text-wrapper-1.40.0-r1.ebuild,v 1.1 2014/08/22 20:30:57 axs Exp $

EAPI=5

MY_PN=Text-Wrapper
MODULE_AUTHOR=CJM
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Word wrap text by breaking long lines"

SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE=""

SRC_TEST=do
