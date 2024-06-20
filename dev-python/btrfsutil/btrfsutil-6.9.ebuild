# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/dsterba.asc

inherit distutils-r1 verify-sig

DESCRIPTION="Library for managing Btrfs filesystems"
HOMEPAGE="https://github.com/kdave/btrfs-progs"

MY_PN="btrfs-progs"
MY_PV="v${PV/_/-}"
MY_P="${MY_PN}-${MY_PV}"
SRC_URI="
	https://mirrors.edge.kernel.org/pub/linux/kernel/people/kdave/${MY_PN}/${MY_P}.tar.xz
	verify-sig? ( https://mirrors.edge.kernel.org/pub/linux/kernel/people/kdave/${MY_PN}/${MY_P}.tar.sign )
"
S="${WORKDIR}/${MY_P}/libbtrfsutil/python"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

DEPEND="~sys-fs/btrfs-progs-${PV}"
RDEPEND="${DEPEND}"

distutils_enable_tests unittest

RDEPEND+=" !sys-fs/btrfs-progs[python(-)]"

src_unpack() {
	if use verify-sig ; then
		verify-sig_verify_detached \
			<(xz -cd "${DISTDIR}"/${MY_P}.tar.xz) \
			"${DISTDIR}"/${MY_P}.tar.sign
	fi
	default
}
