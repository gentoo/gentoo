# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/dsterba.asc

inherit distutils-r1 verify-sig

DESCRIPTION="Library for managing Btrfs filesystems"
HOMEPAGE="https://btrfs.readthedocs.io/en/latest/"

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

DEPEND="sys-fs/btrfs-progs"
RDEPEND="${DEPEND}"

distutils_enable_tests unittest

src_unpack() {
	if use verify-sig ; then
		mkdir "${T}"/verify-sig || die
		pushd "${T}"/verify-sig >/dev/null || die

		# Upstream sign the decompressed .tar
		# Let's do it separately in ${T} then cleanup to avoid external
		# effects on normal unpack.
		cp "${DISTDIR}"/${MY_P}.tar.xz . || die
		xz -d ${MY_P}.tar.xz || die
		verify-sig_verify_detached ${MY_P}.tar "${DISTDIR}"/${MY_P}.tar.sign

		popd >/dev/null || die
		unpack "${T}"/verify-sig/${MY_P}.tar
		rm -r "${T}"/verify-sig || die
	else
		default
	fi
}
