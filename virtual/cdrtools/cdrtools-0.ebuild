# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for command-line recorders cdrtools and cdrkit"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

RDEPEND="|| ( app-cdr/cdrtools app-cdr/cdrkit )"
