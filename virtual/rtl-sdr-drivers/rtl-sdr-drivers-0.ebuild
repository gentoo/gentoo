# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for provider of rtl-sdr drivers"
SLOT=0
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="|| ( net-wireless/rtl-sdr net-wireless/rtl-sdr-blog )"
