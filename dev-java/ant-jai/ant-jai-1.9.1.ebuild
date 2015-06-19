# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-jai/ant-jai-1.9.1.ebuild,v 1.1 2013/07/05 14:11:30 tomwij Exp $

EAPI="5"

ANT_TASK_DEPNAME="sun-jai-bin"

inherit ant-tasks

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"

# Unmigrated, has textrels and there's also some source one now too.
DEPEND=">=dev-java/sun-jai-bin-1.1.2.01-r1"
RDEPEND="${DEPEND}"
