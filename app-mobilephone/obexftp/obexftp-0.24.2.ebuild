# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
USE_RUBY="ruby23 ruby24 ruby25"

inherit cmake-utils python-single-r1 ruby-single

DESCRIPTION="File transfer over OBEX for mobile phones"
HOMEPAGE="http://dev.zuckschwerdt.org/openobex/wiki/ObexFtp"
SRC_URI="mirror://sourceforge/openobex/${P}-Source.tar.gz"
SLOT="0"

LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ppc x86"

# bluetooth support is not really optional, bug #529068
IUSE="perl python ruby tcl"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/openobex-1.7
	net-wireless/bluez
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( ${RUBY_DEPS} )
	tcl? ( dev-lang/tcl:0= )
"
DEPEND="${RDEPEND}
	perl? ( dev-lang/swig )
	python? ( dev-lang/swig )
	ruby? ( dev-lang/swig )
	tcl? ( dev-lang/swig )
	virtual/pkgconfig
"

S=${WORKDIR}/${P}-Source

PATCHES=(
	"${FILESDIR}"/${PN}-0.23-gentoo.patch
	"${FILESDIR}"/${PN}-0.24-config.patch
	"${FILESDIR}"/${PN}-0.24-enable_bluetooth.patch
	"${FILESDIR}"/${PN}-0.24-python_sitedir.patch
	"${FILESDIR}"/${PN}-0.24-norpath.patch
	"${FILESDIR}"/${P}-parallel-build.patch
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
