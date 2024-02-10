# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools perl-module

DESCRIPTION="Suite of tools for moving data between a Palm device and a desktop"
# this is a new mirror; the distfile has the same content inside the tarball,
# but the tarball itself doesn't match due to recompression and Git
# indirection.
HOMEPAGE="https://github.com/jichu4n/pilot-link"
SRC_URI="
	mirror://gentoo/${P}.tar.bz2
	https://dev.gentoo.org/~soap/distfiles/${P}-gentoo-patchset-r2.tar.xz"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bluetooth perl png threads usb"
RESTRICT="test" #672872

RDEPEND="
	dev-libs/popt
	sys-libs/ncurses:=
	sys-libs/readline:=
	virtual/libiconv
	bluetooth? ( net-wireless/bluez )
	perl? ( dev-lang/perl:= )
	png? ( media-libs/libpng:= )
	usb? ( virtual/libusb:0 )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	perl? ( dev-lang/perl )"

PATCHES=( "${WORKDIR}/${P}-gentoo-patchset"/ )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# tcl/tk support is disabled as per upstream request.
	# readline is not really optional, bug #626504
	# Does not build with Java 8
	# Does not build with Python 3, bug #735238
	econf \
		--includedir="${EPREFIX}"/usr/include/libpisock \
		--enable-conduits \
		--with-readline \
		$(use_enable threads) \
		$(use_enable usb libusb) \
		$(use_with png libpng) \
		$(use_with bluetooth bluez) \
		$(use_with perl) \
		--without-java \
		--without-tcl \
		--without-python

	if use perl; then
		perl_set_version

		cd bindings/Perl || die
		perl-module_src_configure
	fi
}

src_compile() {
	emake

	if use perl; then
		cd bindings/Perl || die
		local mymake=( OTHERLDFLAGS="${LDFLAGS} -L../../libpisock/.libs -lpisock" ) #308629
		perl-module_src_compile
	fi
}

src_install() {
	default
	dodoc doc/{README*,TODO}

	if use perl; then
		cd bindings/Perl || die
		perl-module_src_install
	fi

	find "${ED}" -name '*.la' -delete || die
}
