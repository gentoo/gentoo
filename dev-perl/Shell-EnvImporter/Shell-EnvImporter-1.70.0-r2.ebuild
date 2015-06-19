# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Shell-EnvImporter/Shell-EnvImporter-1.70.0-r2.ebuild,v 1.1 2014/12/20 17:26:34 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DFARALDO
MODULE_VERSION=1.07
inherit perl-module

DESCRIPTION="Import environment variable changes from external commands or shell scripts"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=">=dev-perl/Class-MethodMaker-2"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-perl520.patch" )

SRC_TEST=no
