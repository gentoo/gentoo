# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# TODO: test phase

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"
inherit distutils-r1

DESCRIPTION="Python framework for efficient cluster administration"
HOMEPAGE="https://cea-hpc.github.com/clustershell/"
SRC_URI="https://github.com/cea-hpc/clustershell/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc libressl test"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND="${CDEPEND}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"

RESTRICT="test" # currently fail

src_install() {
	distutils-r1_src_install

	if use doc ; then
		local i
		for i in $(ls -I man "${S}"/doc) ; do
			dodoc -r doc/${i}
		done
	fi

	doman doc/man/man*/*

	insinto /etc/${PN}
	doins -r conf/*
}

python_test() {
	cd tests || die
	nosetests -sv --all-modules || die
}

pkg_postinst() {
	einfo
	einfo "Some default system-wide config files have been installed into"
	einfo "/etc/${PN}"
	einfo
}
