# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils libtool multilib-minimal versionator

DESCRIPTION="A TLS 1.2 and SSL 3.0 implementation for the GNU project"
HOMEPAGE="http://www.gnutls.org/"
SRC_URI="mirror://gnupg/gnutls/v$(get_version_component_range 1-2)/${P}.tar.xz"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0/30" # libgnutls.so number
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE_LINGUAS=" en cs de fi fr it ms nl pl sv uk vi zh_CN"
IUSE="+cxx dane doc examples guile +idn nls +openssl pkcs11 sslv2 +sslv3 static-libs test test-full +tls-heartbeat tools valgrind zlib ${IUSE_LINGUAS// / linguas_}"

REQUIRED_USE="
	test-full? ( pkcs11 openssl idn tools zlib )"

# NOTICE: sys-devel/autogen is required at runtime as we
# use system libopts
RDEPEND=">=dev-libs/libtasn1-4.9:=[${MULTILIB_USEDEP}]
	dev-libs/libunistring:=[${MULTILIB_USEDEP}]
	>=dev-libs/nettle-3.1:=[gmp,${MULTILIB_USEDEP}]
	>=dev-libs/gmp-5.1.3-r1:=[${MULTILIB_USEDEP}]
	tools? ( sys-devel/autogen )
	dane? ( >=net-dns/unbound-1.4.20[${MULTILIB_USEDEP}] )
	guile? ( >=dev-scheme/guile-1.8:=[networking] )
	nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )
	pkcs11? ( >=app-crypt/p11-kit-0.23.1[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	idn? ( >=net-dns/libidn2-0.16-r1[${MULTILIB_USEDEP}] )
	valgrind? ( dev-util/valgrind )
	test-full? (
		app-crypt/dieharder
		app-misc/datefudge
		dev-libs/softhsm:2[-bindist]
		net-dialup/ppp
		net-misc/socat
	)
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	>=sys-devel/automake-1.11.6
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	doc? ( dev-util/gtk-doc )
	nls? ( sys-devel/gettext )
	test? ( app-misc/datefudge )"

DOCS=(
	README.md
	doc/certtool.cfg
)

HTML_DOCS=()

pkg_setup() {
	# bug#520818
	export TZ=UTC

	use doc && HTML_DOCS+=(
		doc/gnutls.html
	)
}

src_prepare() {
	default

	# force regeneration of autogen-ed files
	local file
	for file in $(grep -l AutoGen-ed src/*.c) ; do
		rm src/$(basename ${file} .c).{c,h} || die
	done

	# Use sane .so versioning on FreeBSD.
	elibtoolize
}

multilib_src_configure() {
	LINGUAS="${LINGUAS//en/en@boldquot en@quot}"

	# remove magic of library detection
	# bug#438222
	local libconf=($("${S}/configure" --help | grep -- '--without-.*-prefix' | sed -e 's/^ *\([^ ]*\) .*/\1/g'))

	# TPM needs to be tested before being enabled
	# hardware-accell is disabled on OSX because the asm files force
	#   GNU-stack (as doesn't support that) and when that's removed ld
	#   complains about duplicate symbols
	ECONF_SOURCE=${S} econf \
		--without-included-libtasn1 \
		$(use_enable cxx) \
		$(use_enable dane libdane) \
		$(multilib_native_enable manpages) \
		$(multilib_native_use_enable tools) \
		$(multilib_native_use_enable doc) \
		$(multilib_native_use_enable doc gtk-doc) \
		$(multilib_native_use_enable guile) \
		$(multilib_native_use_enable test tests) \
		$(multilib_native_use_enable valgrind valgrind-tests) \
		$(use_enable nls) \
		$(use_enable openssl openssl-compatibility) \
		$(use_enable tls-heartbeat heartbeat-support) \
		$(use_enable sslv2 ssl2-support) \
		$(use_enable sslv3 ssl3-support) \
		$(use_enable static-libs static) \
		$(use_with pkcs11 p11-kit) \
		$(use_with zlib) \
		$(use_with idn) \
		$(use_with idn libidn2) \
		--without-tpm \
		--with-unbound-root-key-file="${EPREFIX}/etc/dnssec/root-anchors.txt" \
		"${libconf[@]}" \
		$([[ ${CHOST} == *-darwin* ]] && echo --disable-hardware-acceleration)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all

	if use examples; then
		docinto examples
		dodoc doc/examples/*.c
	fi
}
