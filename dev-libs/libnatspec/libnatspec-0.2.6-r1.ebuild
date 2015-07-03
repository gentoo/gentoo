# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libnatspec/libnatspec-0.2.6-r1.ebuild,v 1.10 2015/07/03 10:10:21 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-single-r1

DESCRIPTION="library to smooth charset/localization issues"
HOMEPAGE="http://natspec.sourceforge.net/"
SRC_URI="mirror://sourceforge/natspec/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/popt
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	python? ( dev-lang/tcl:0= )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-iconv.patch
	# regenerate to fix imcompatible readlink usage
	rm -f "${S}"/ltmain.sh "${S}"/libtool || die
	eautoreconf
}

src_configure() {
	use doc || export ac_cv_prog_DOX=no
	# braindead configure script does not disable python on --without-python
	econf $(use python && use_with python)
}
