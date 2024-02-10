# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-base toolchain-funcs

DESCRIPTION="A library of general-purpose, non-graphical Objective C objects"
HOMEPAGE="https://gnustep.github.io"
SRC_URI="https://github.com/gnustep/libs-base/releases/download/base-${PV//./_}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="+gnutls +iconv +icu +libffi zeroconf"

RDEPEND="${GNUSTEP_CORE_DEPEND}
	>=gnustep-base/gnustep-make-2.6.0
	gnutls? ( net-libs/gnutls:= )
	iconv? ( virtual/libiconv )
	icu? ( >=dev-libs/icu-49.0:= )
	libffi? ( dev-libs/libffi:= )
	!libffi? (
		dev-libs/ffcall
		gnustep-base/gnustep-make[-native-exceptions]
	)
	>=dev-libs/libxml2-2.6
	>=dev-libs/libxslt-1.1
	>=dev-libs/gmp-4.1:=
	>=sys-libs/zlib-1.2
	zeroconf? ( net-dns/avahi )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.26.0-no_compress_man.patch
	"${FILESDIR}"/${PN}-1.29.0-libxml2-2.11.patch
)

src_configure() {
	egnustep_env

	local myconf=(
		$(use_enable libffi)
		$(use_enable !libffi ffcall)
	)
	use libffi &&
		myconf+=( --with-ffi-include=$($(tc-getPKG_CONFIG) --variable=includedir libffi) )

	myconf+=(
		$(use_enable gnutls tls)
		$(use_enable iconv)
		$(use_enable icu)
		$(use_enable zeroconf)
		--with-xml-prefix="${ESYSROOT}"/usr
		--with-gmp-include="${ESYSROOT}"/usr/include
		--with-gmp-library="${ESYSROOT}"/usr/$(get_libdir)
		--with-default-config="${ESYSROOT}"/etc/GNUstep/GNUstep.conf
	)

	econf "${myconf[@]}"
}

src_install() {
	# We need to set LD_LIBRARY_PATH because the doc generation program
	# uses the gnustep-base libraries. Since egnustep_env "cleans the
	# environment" including our LD_LIBRARY_PATH, we're left no choice
	# but doing it like this.

	egnustep_env
	egnustep_install

	if use doc ; then
		export LD_LIBRARY_PATH="${S}/Source/obj:${LD_LIBRARY_PATH}"
		egnustep_doc
	fi
	egnustep_install_config
}
