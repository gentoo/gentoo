# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A set of eselect modules for Java"
HOMEPAGE="https://www.gentoo.org/proj/en/java/"
SRC_URI="https://dev.gentoo.org/~sera/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc64 x86 ~amd64-fbsd ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	!app-eselect/eselect-ecj
	!app-eselect/eselect-maven
	!<dev-java/java-config-2.2
	app-admin/eselect"
