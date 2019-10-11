# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools python-single-r1

DESCRIPTION="library to smooth charset/localization issues"
HOMEPAGE="http://natspec.sourceforge.net/"
SRC_URI="mirror://sourceforge/natspec/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/popt
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	python? ( dev-lang/tcl:0= )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.6-iconv.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	# regenerate to fix imcompatible readlink usage
	rm -f "${S}"/ltmain.sh "${S}"/libtool || die
	eautoreconf
}

src_configure() {
	use doc || export ac_cv_prog_DOX=no
	# braindead configure script does not disable python on --without-python
	econf $(use python && use_with python)
}
