# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A full-featured file system for online data storage"
HOMEPAGE="https://bitbucket.org/nikratio/s3ql/"
SRC_URI="https://www.bitbucket.org/nikratio/s3ql/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="contrib doc test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/apsw-3.7.0[${PYTHON_USEDEP}]
	>=dev-python/llfuse-0.37[${PYTHON_USEDEP}]
	dev-python/pycryptopp[${PYTHON_USEDEP}]
	dev-python/pyliblzma[${PYTHON_USEDEP}]
	sys-fs/fuse"
DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		net-misc/rsync[xattr]
	)"

python_prepare_all() {
	# use system setuptools
	sed -i '/use_setuptools/d' setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	if [[ ${EUID} -ne 0 ]] ; then
		ewarn "Skipping tests: root privileges are required so userpriv must be disabled"
	else
		addwrite /dev/fuse
		esetup.py test
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	if use contrib ; then
		exeinto /usr/share/doc/${PF}/contrib
		docompress -x /usr/share/doc/${PF}/contrib
		doexe contrib/*.{py,sh}
		doman contrib/*.1
	fi

	if use doc ; then
		dodoc doc/manual.pdf
		dohtml -r doc/html/*
	fi
}
