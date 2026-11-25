# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

CommitId=78082a7801dae8175d95157cfd212b4f8fa327b0

MY_P="${PN}-v${PV}"
DESCRIPTION="Efficient and accurate implementation of complex error functions"
HOMEPAGE="https://jugit.fz-juelich.de/mlz/lib/cerf"
SRC_URI="https://jugit.fz-juelich.de/mlz/lib/cerf/-/archive/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}"/cerf-v${PV}-${CommitId}

LICENSE="MIT"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
