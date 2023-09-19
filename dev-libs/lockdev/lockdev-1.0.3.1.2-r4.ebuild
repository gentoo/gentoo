# Copyright 2001-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENTOO_DEPEND_ON_PERL="no"

inherit perl-module autotools multilib-minimal

MAJOR=$(ver_cut 1)
MY_PV=$(ver_cut 1-3)
MY_P=${PN}-${MY_PV}
DEB_PV=$(ver_rs 3 '-')
DEB_P=${PN}_${DEB_PV}

DESCRIPTION="Library for locking devices"
HOMEPAGE="http://packages.debian.org/source/sid/lockdev"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_P}.diff.gz
"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="perl"

PATCHES=(
	"${WORKDIR}/${DEB_P}.diff"
	"${FILESDIR}/${MY_P}-add-autotools.patch"
	"${FILESDIR}/${MY_P}-fix-perl.patch"
	"${FILESDIR}/${MY_P}-major-minor.patch"
)

PERL_S=./LockDev

pkg_setup() {
	use perl && perl_set_version
}

src_prepare() {
	default

	eautoreconf

	# perl module build
	multilib_copy_sources
}

multilib_src_configure() {
	econf

	if multilib_is_native_abi && use perl; then
		cd "${PERL_S}" || die
		perl-module_src_configure
	fi
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi && use perl; then
		cd "${PERL_S}" || die
		perl-module_src_compile
	fi
}

multilib_src_test() {
	if multilib_is_native_abi && use perl; then
		cd "${PERL_S}" || die
		DIST_TEST="do"
		export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}${BUILD_DIR}/.libs"
		perl-module_src_test
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use perl; then
		cd "${PERL_S}" || die
		mytargets="pure_install"
		perl-module_src_install
	fi
}

multilib_src_install_all() {
	dodoc AUTHORS ChangeLog* debian/NEWS README.debug
	newdoc debian/changelog changelog.debian

	find "${ED}" -name '*.la' -delete || die
}

pkg_preinst() {
	use perl && perl_set_version
}
