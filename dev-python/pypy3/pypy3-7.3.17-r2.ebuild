# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit python-utils-r1

PYVER=3.10
DESCRIPTION="A fast, compliant alternative implementation of the Python (${PYVER}) language"
HOMEPAGE="
	https://pypy.org/
	https://foss.heptapod.net/pypy/pypy/
"
S=${WORKDIR}

LICENSE="MIT"
SLOT="0/pypy310-pp73-384"
KEYWORDS="amd64 ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+gdbm ncurses sqlite +test-install tk"

RDEPEND="
	=dev-python/pypy3_10-${PV}*:${SLOT}[gdbm?,ncurses?,sqlite?,test-install(+)?,tk?]
"

src_install() {
	dodir /usr/bin
	dosym pypy${PYVER} /usr/bin/pypy3

	# install symlinks for python-exec
	local EPYTHON=pypy3
	local scriptdir=${D}$(python_get_scriptdir)
	mkdir -p "${scriptdir}" || die
	ln -s "../../../bin/pypy3" "${scriptdir}/python3" || die
	ln -s python3 "${scriptdir}/python" || die
}
