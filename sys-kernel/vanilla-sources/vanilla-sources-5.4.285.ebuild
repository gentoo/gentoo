# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_SECURITY_UNSUPPORTED="1"
ETYPE="sources"
inherit kernel-2
detect_version

DESCRIPTION="Full sources for the Linux kernel"
HOMEPAGE="https://www.kernel.org"
SRC_URI="${KERNEL_URI}"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
