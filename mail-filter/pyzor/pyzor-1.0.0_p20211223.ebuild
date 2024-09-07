# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_COMMIT="2dbe627c1ec245db206cdc73bf1f9d785f1512d8"
DESCRIPTION="A distributed, collaborative spam detection and filtering network"
HOMEPAGE="https://github.com/SpamExperts/pyzor"
SRC_URI="https://github.com/SpamExperts/pyzor/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc gdbm mysql pyzord redis selinux test"
RESTRICT="!test? ( test )"

RDEPEND="
	pyzord? (
		gdbm? ( $(python_gen_impl_dep 'gdbm') )
		mysql? ( dev-python/mysqlclient[${PYTHON_USEDEP}] )
		redis? ( dev-python/redis[${PYTHON_USEDEP}] )
	)
	selinux? ( sec-policy/selinux-pyzor )
"
BDEPEND="
	test? (
		$(python_gen_impl_dep 'gdbm')
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/redis[${PYTHON_USEDEP}]
	)
"

REQUIRED_USE="
	pyzord? ( || ( gdbm redis ) )
"

distutils_enable_sphinx docs

python_test() {
	epytest -vv tests/unit
}

src_install() {
	distutils-r1_src_install

	if use pyzord; then
		dodir /usr/sbin
		mv "${ED}"/usr/bin/pyzord* "${ED}/usr/sbin" \
		   || die "failed to relocate pyzord"
	else
		rm "${ED}"/usr/bin/pyzord* || die "failed to remove pyzord"
	fi
}
