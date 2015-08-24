# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_DEPEND="2"

inherit eutils python distutils

MY_P="sitemap_gen_${PV}"

DESCRIPTION="A python script which will generate an XML sitemap for your web site"
HOMEPAGE="https://sitemap-generators.googlecode.com/"
SRC_URI="https://sitemap-generators.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS="AUTHORS ChangeLog example_* README"

S=${WORKDIR}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}"/${P}.patch
	mv sitemap_gen.py sitemap_gen || die
}
