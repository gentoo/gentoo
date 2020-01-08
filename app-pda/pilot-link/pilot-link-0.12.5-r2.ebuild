# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools distutils-r1 perl-module java-pkg-opt-2

DESCRIPTION="Suite of tools for moving data between a Palm device and a desktop"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/${P}-gentoo-patchset.tar.bz2"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="bluetooth debug java perl png python static-libs threads usb"

COMMON_DEPEND="
	dev-libs/popt
	>=sys-libs/ncurses-5.7-r7:0=
	>=sys-libs/readline-6:0=
	virtual/libiconv
	bluetooth? ( net-wireless/bluez )
	perl? ( >=dev-lang/perl-5.12 )
	png? ( media-libs/libpng:0= )
	usb? ( virtual/libusb:0 )
"
DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.4 )
"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.4 )
"

RESTRICT="test" #672872

src_prepare() {
	default

	eapply -p0 "${WORKDIR}/${P}-gentoo-patchset"/${PN}-0.12.3-java-install.patch
	eapply -p0 "${WORKDIR}/${P}-gentoo-patchset"/${PN}-0.12.3-respect-javacflags.patch
	eapply -p0 "${WORKDIR}/${P}-gentoo-patchset"/${PN}-0.12.2-werror_194921.patch
	eapply -p1 "${WORKDIR}/${P}-gentoo-patchset"/${PN}-0.12.2-threads.patch
	eapply -p0 "${WORKDIR}/${P}-gentoo-patchset"/${PN}-0.12.3-libpng14.patch
	eapply -p1 "${WORKDIR}/${P}-gentoo-patchset"/${PN}-0.12.3-png.patch
	eapply -p0 "${WORKDIR}/${P}-gentoo-patchset"/${PN}-0.12.3-distutils.patch
	eapply -p1 "${WORKDIR}/${P}-gentoo-patchset"/${PN}-0.12.3-libusb-compat-usb_open.patch
	eapply -p1 "${WORKDIR}/${P}-gentoo-patchset"/${PN}-0.12.5-perl514.patch

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #467600

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	# tcl/tk support is disabled as per upstream request.
	# readline is not really optional, bug #626504
	econf \
		--includedir="${EPREFIX}"/usr/include/libpisock \
		$(use_enable static-libs static) \
		--enable-conduits \
		--with-readline \
		$(use_enable threads) \
		$(use_enable usb libusb) \
		$(use_enable debug) \
		$(use_with png libpng) \
		$(use_with bluetooth bluez) \
		$(use_with perl) \
		$(use_with java) \
		--without-tcl \
		$(use_with python)
}

src_compile() {
	emake

	if use perl; then
		cd "${S}"/bindings/Perl
		perl-module_src_configure
		local mymake=( OTHERLDFLAGS="${LDFLAGS} -L../../libpisock/.libs -lpisock" ) #308629
		perl-module_src_compile
	fi

	if use python; then
		cd "${S}"/bindings/Python
		distutils-r1_src_compile
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog NEWS README doc/{README*,TODO}

	if use java; then
		cd "${S}"/bindings/Java
		java-pkg_newjar ${PN}.jar
		java-pkg_doso libjpisock.so
	fi

	if use perl; then
		cd "${S}"/bindings/Perl
		perl-module_src_install
	fi

	if use python; then
		cd "${S}"/bindings/Python
		distutils-r1_src_install
	fi

	find "${D}" -name '*.la' -delete || die
}

pkg_preinst() {
	perl_set_version
	java-pkg-opt-2_pkg_preinst
}
