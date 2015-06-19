# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/lockdev/lockdev-1.0.3.1.2-r3.ebuild,v 1.11 2014/11/19 19:49:24 dilfridge Exp $

EAPI=5

GENTOO_DEPEND_ON_PERL="no"
inherit toolchain-funcs perl-module eutils versionator autotools multilib-minimal

MAJOR=$(get_major_version)
MY_PV=$(get_version_component_range 1-3)
MY_P=${PN}-${MY_PV}
DEB_PV=$(replace_version_separator 3 '-')
DEB_P=${PN}_${DEB_PV}

DESCRIPTION="Library for locking devices"
HOMEPAGE="http://packages.debian.org/source/sid/lockdev"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_P}.diff.gz
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="perl"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${MY_P}-add-autotools.patch"
	"${FILESDIR}/${MY_P}-fix-perl.patch"
)

S=${WORKDIR}/${PN}-${MY_PV}
PERL_S=./LockDev

pkg_setup() {
	use perl && perl_set_version
}

src_prepare() {
	cd "${WORKDIR}" || die
	# Note: we do *not* want to be in ${S} for this, as that breaks the patch
	epatch "${WORKDIR}/${DEB_P}.diff"

	cd "${S}" || die
	epatch "${PATCHES[@]}"
	epatch_user

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
		SRC_TEST="do"
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

	prune_libtool_files --all
}

pkg_preinst() {
	use perl && perl_set_version
}
