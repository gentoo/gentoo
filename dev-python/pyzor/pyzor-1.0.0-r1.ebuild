# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

MY_PV="1-0-0"
DESCRIPTION="A distributed, collaborative spam detection and filtering network"
HOMEPAGE="https://github.com/SpamExperts/pyzor"
SRC_URI="${HOMEPAGE}/archive/release-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="doc gdbm gevent mysql pyzord redis test"

# The mysql-python library is always required for the MySQL engine. We
# depend on it conditionally here because otherwise repoman will balk at
# the potential conflict between PYTHON_TARGETS and USE=mysql. But as a
# result, if you try to use the MySQL engine with python-3.x, it just
# won't work because you'll be missing the library.
RDEPEND="pyzord? (
	gdbm? ( $(python_gen_impl_dep 'gdbm') )
	mysql? ( $(python_gen_cond_dep \
				'dev-python/mysql-python[${PYTHON_USEDEP}]' python2_7) )
	redis? ( dev-python/redis-py[${PYTHON_USEDEP}] )
	gevent? ( dev-python/gevent[${PYTHON_USEDEP}] )
)"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( ${RDEPEND} )"

# TODO: maybe upstream would support skipping tests for which the
# dependencies are missing?
REQUIRED_USE="pyzord? ( || ( gdbm mysql redis ) )
	test? ( gdbm mysql redis )"
S="${WORKDIR}/${PN}-release-${MY_PV}"

PATCHES=(
	"${FILESDIR}/read-stdin-as-binary-in-get_input_msg.patch"
	"${FILESDIR}/unfix-configparser-compat-for-2to3.patch"
)

python_test() {
	# The suite is py2 friendly only
	if ! python_is_python3; then
		PYTHONPATH=. "${PYTHON}" ./tests/unit/__init__.py
	fi
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && HTML_DOCS=( docs/.build/html/. )
	distutils-r1_python_install_all
}

src_install () {
	distutils-r1_src_install

	if use pyzord; then
		dodir /usr/sbin
		mv "${D}"usr/bin/pyzord* "${ED}usr/sbin" \
		   || die "failed to relocate pyzord"
	else
		rm "${D}"usr/bin/pyzord* || die "failed to remove pyzord"
	fi
}
