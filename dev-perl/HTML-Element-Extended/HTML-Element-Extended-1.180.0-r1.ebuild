# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
