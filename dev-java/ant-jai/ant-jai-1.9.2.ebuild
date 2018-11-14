# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

ANT_TASK_DEPNAME="sun-jai-bin"

inherit ant-tasks

KEYWORDS="amd64 ppc64 x86"

# Unmigrated, has textrels and there's also some source one now too.
DEPEND=">=dev-java/sun-jai-bin-1.1.2.01-r1"
RDEPEND="${DEPEND}"
