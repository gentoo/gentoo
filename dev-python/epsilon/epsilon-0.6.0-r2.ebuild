# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1 eutils

DESCRIPTION="Epsilon is a Python utilities package, most famous for its Time class"
HOMEPAGE="http://divmod.org/trac/wiki/DivmodEpsilon https://pypi.python.org/pypi/Epsilon"
SRC_URI="mirror://pypi/${TWISTED_PN:0:1}/${TWISTED_PN}/${TWISTED_P}.tar.gz"

KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-python/twisted-core[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/epsilon_plugincache_portagesandbox.patch" )

# epsilon doesn't install any plugins, so override the default
TWISTED_PLUGINS=()

python_prepare_all() {
	# Rename to avoid file-collisions
	mv bin/benchmark bin/epsilon-benchmark
	sed -i \
		-e "s#bin/benchmark#bin/epsilon-benchmark#" \
		setup.py || die "sed failed"

	#These test are removed upstream
	rm -f epsilon/test/test_sslverify.py epsilon/sslverify.py || die
	#See bug 357157 comment 5 for Ian Delaney's explanation of this fix
	sed -e 's:month) 2004 9:month) 2004 14:' \
		-i epsilon/test/test_extime.py || die
	# Release tests need DivmodCombinator.
	rm -f epsilon/test/test_release.py* epsilon/release.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	dodoc NAME.txt NEWS.txt

	distutils-r1_python_install_all
}
