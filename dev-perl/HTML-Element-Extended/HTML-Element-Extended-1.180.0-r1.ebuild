# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Element-Extended/HTML-Element-Extended-1.180.0-r1.ebuild,v 1.1 2014/08/22 16:17:02 axs Exp $

EAPI=5

MODULE_AUTHOR=MSISK
MODULE_VERSION=1.18
inherit perl-module

DESCRIPTION="Extension for manipulating a table composed of HTML::Element style components"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 x86 ~x86-linux"
IUSE=""

RDEPEND=">=dev-perl/HTML-Tree-3.01"
DEPEND="${RDEPEND}"

SRC_TEST="do"
