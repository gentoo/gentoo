# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-jai/ant-jai-1.9.2.ebuild,v 1.5 2013/10/20 16:31:47 ago Exp $

EAPI="5"

ANT_TASK_DEPNAME="sun-jai-bin"

inherit ant-tasks

KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"

# Unmigrated, has textrels and there's also some source one now too.
DEPEND=">=dev-java/sun-jai-bin-1.1.2.01-r1"
RDEPEND="${DEPEND}"
