# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/elfix.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~blueness/elfix/elfix-${PV}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
	S="${WORKDIR}/elfix-${PV}"
fi

DESCRIPTION="Python module to get or set either PT_PAX and/or XATTR_PAX flags"
HOMEPAGE="https://dev.gentoo.org/~blueness/elfix/
	https://www.gentoo.org/proj/en/hardened/pax-quickstart.xml"

LICENSE="GPL-3"
SLOT="0"
IUSE="+ptpax +xtpax"

REQUIRED_USE="|| ( ptpax xtpax )"

RDEPEND="
	ptpax? ( dev-libs/elfutils )
	xtpax? ( sys-apps/attr )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${RDEPEND}"

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
