# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Diff/Text-Diff-1.410.0-r1.ebuild,v 1.2 2015/03/09 12:12:41 zlogene Exp $

EAPI=5

MODULE_AUTHOR=OVID
MODULE_VERSION=1.41
inherit perl-module

DESCRIPTION="Easily create test classes in an xUnit style"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="dev-perl/Algorithm-Diff"
DEPEND="${RDEPEND}"

SRC_TEST=do
