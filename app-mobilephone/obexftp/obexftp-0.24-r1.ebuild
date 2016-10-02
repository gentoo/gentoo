# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
inherit cmake-utils python-single-r1 python-utils-r1 eutils multilib

DESCRIPTION="File transfer over OBEX for mobile phones"
HOMEPAGE="http://dev.zuckschwerdt.org/openobex/wiki/ObexFtp"
SRC_URI="mirror://sourceforge/openobex/${P}-Source.tar.gz"
SLOT="0"

LICENSE="GPL-2"
KEYWORDS="~amd64 hppa ~ppc ~x86"

# bluetooth support is not really optional, bug #529068
IUSE="perl python ruby tcl" #bluetooth

RDEPEND="
	>=dev-libs/openobex-1.7
	net-wireless/bluez
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( || ( dev-lang/ruby:2.0 dev-lang/ruby:1.9 ) )
	tcl? ( dev-lang/tcl:0= )
"
DEPEND="
	${RDEPEND}
	perl? ( dev-lang/swig )
	python? ( dev-lang/swig )
	ruby? ( dev-lang/swig )
	tcl? ( dev-lang/swig )
	virtual/pkgconfig
"

S=${WORKDIR}/${P}-Source

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.23-gentoo.patch
	"${FILESDIR}"/${PN}-0.24-config.patch
	"${FILESDIR}"/${PN}-0.24-enable_bluetooth.patch
	"${FILESDIR}"/${PN}-0.24-python_sitedir.patch
	"${FILESDIR}"/${PN}-0.24-norpath.patch
	"${FILESDIR}"/${PN}-0.24-fuse.patch
	"${FILESDIR}"/${PN}-0.24-pkgconfig_requires.patch
)

src_configure() {
# -DENABLE_BLUETOOTH=$(usex bluetooth)
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_SKIP_RPATH=ON
		-DENABLE_PERL=$(usex perl)
		-DENABLE_BLUETOOTH=yes
		-DENABLE_PYTHON=$(usex python)
		$(usex python -DPYTHON_SITE_DIR=$(python_get_sitedir) '')
		-DENABLE_RUBY=$(usex ruby)
		-DENABLE_TCL=$(usex tcl)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	rm -rf "${ED}"/usr/share/doc/${PN}/html || die #524866
}
