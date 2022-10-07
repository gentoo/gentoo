# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal autotools virtualx

DESCRIPTION="Provides a C++ API for D-BUS"
HOMEPAGE="https://sourceforge.net/projects/dbus-cplusplus/"
SRC_URI="mirror://sourceforge/dbus-cplusplus/lib${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc ecore glib test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/expat
	sys-apps/dbus[${MULTILIB_USEDEP}]
	ecore? ( dev-libs/efl )
	glib? ( dev-libs/glib:2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-util/cppunit[${MULTILIB_USEDEP}]"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( sys-apps/dbus[X,${MULTILIB_USEDEP}] )"

S="${WORKDIR}/lib${P}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-4.7.patch #424707
	"${FILESDIR}"/${PN}-gcc7.patch #622790
	"${FILESDIR}"/${P}-gcc12.patch
	"${FILESDIR}"/${PN}-0.9.0-enable-tests.patch #873487
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	# TODO : add ecore multilib support if/when it is multilibified
	ECONF_SOURCE="${S}" econf \
		--disable-examples \
		--disable-static \
		$(multilib_native_use_enable doc doxygen-docs) \
		$(multilib_native_use_enable ecore) \
		$(use_enable glib) \
		$(use_enable test tests) \
		PTHREAD_LIBS=-lpthread
	# ACX_PTHREAD sets PTHREAD_CFLAGS but not PTHREAD_LIBS for some reason...

	if multilib_is_native_abi; then
		# docs don't like out-of-source builds
		local d
		for d in img html; do
			ln -s "${S}"/doc/${d} "${BUILD_DIR}"/doc/${d} || die
		done
	fi
}

src_test() {
	virtx multilib-minimal_src_test
}

multilib_src_install_all() {
	use doc && HTML_DOCS=( doc/html/. )
	einstalldocs

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
