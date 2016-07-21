# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='ssl'

inherit distutils-r1

DESCRIPTION="Configuration management tool"
HOMEPAGE="http://bcfg2.org"
SRC_URI="ftp://ftp.mcs.anl.gov/pub/bcfg/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="doc cheetah genshi server"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="app-portage/gentoolkit[${PYTHON_USEDEP}]
	cheetah? ( dev-python/cheetah[${PYTHON_USEDEP}] )
	genshi? ( dev-python/genshi[${PYTHON_USEDEP}] )
	server? (
		dev-libs/libgamin[python,${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		!kernel_linux? ( virtual/fam ) )"

python_compile_all() {
	if use doc; then
		einfo "Building Bcfg2 documentation"
		sphinx-build doc doc_output || die
	fi
}

python_install() {
	distutils-r1_python_install \
		--record=PY_SERVER_LIBS

	if ! use server; then
		rm -f "${ED%/}"/usr/bin/bcfg2-* || die
		rm -f "${D%/}$(python_get_scriptdir)"/bcfg2-* || die
		rm -rf "${ED%/}"/usr/share/bcfg2 || die
		rm -rf "${ED%/}"/usr/share/man/man8 || die
	else
		newinitd "${FILESDIR}/${PN}-server-1.2.0.rc" bcfg2-server
	fi

	insinto /etc
	doins examples/bcfg2.conf

	if use doc; then
		cd doc_output || die
		docinto html
		dodoc -r [a-z]* _images _static
	fi
}

pkg_postinst () {
	if use server; then
		einfo "If this is a new installation, you probably need to run:"
		einfo "    bcfg2-admin init"
	fi
}
