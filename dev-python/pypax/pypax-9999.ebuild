# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/elfix.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~blueness/elfix/elfix-${PV}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
	S="${WORKDIR}/elfix-${PV}"
fi

DESCRIPTION="Python module to get or set either PT_PAX and/or XATTR_PAX flags"
HOMEPAGE="https://dev.gentoo.org/~blueness/elfix/
	https://wiki.gentoo.org/wiki/Project:Hardened/PaX_Quickstart"

LICENSE="GPL-3"
SLOT="0"
IUSE="+ptpax +xtpax"
REQUIRED_USE="|| ( ptpax xtpax )"

RDEPEND="
	ptpax? ( dev-libs/elfutils )
	xtpax? ( sys-apps/attr )"
DEPEND="${RDEPEND}"

src_compile() {
	cd scripts || die
	unset PTPAX
	unset XTPAX
	use ptpax && export PTPAX="yes"
	use xtpax && export XTPAX="yes"
	distutils-r1_src_compile
}

src_install() {
	cd scripts || die
	distutils-r1_src_install
}
