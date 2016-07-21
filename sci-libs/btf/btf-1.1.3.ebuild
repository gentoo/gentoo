# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=yes
inherit autotools-utils

MY_PN=BTF

DESCRIPTION="Algorithm for matrix permutation into block triangular form"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/btf/"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="sci-libs/ufconfig"
RDEPEND=""

DOCS=( README.txt Doc/ChangeLog )
PATCHES=( "${FILESDIR}"/${PN}-1.0.1-autotools.patch )

S="${WORKDIR}/${MY_PN}"
