# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Parse-ExuberantCTags/Parse-ExuberantCTags-1.20.0-r1.ebuild,v 1.1 2014/08/26 15:31:45 axs Exp $

EAPI=5

MODULE_AUTHOR=SMUELLER
MODULE_VERSION=1.02
inherit perl-module

DESCRIPTION="Efficiently parse exuberant ctags files"

# contains readtags.c from ctags
LICENSE="${LICENSE} public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST=do
