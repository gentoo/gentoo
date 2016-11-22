# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools libtool eutils multilib-minimal versionator

DESCRIPTION="A TLS 1.2 and SSL 3.0 implementation for the GNU project"
HOMEPAGE="http://www.gnutls.org/"
SRC_URI="mirror://gnupg/gnutls/v$(get_version_component_range 1-2)/${P}.tar.xz"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0/30" # libgnutls.so number
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE_LINGUAS=" en cs de fi fr it ms nl pl sv uk vi zh_CN"
IUSE="+cxx dane doc examples guile idn nls +openssl pkcs11 sslv2 +sslv3 static-libs test +tls-heartbeat +tools zlib ${IUSE_LINGUAS// / linguas_}"

# NOTICE: sys-devel/autogen is required at runtime as we
# use system libopts
RDEPEND=">=dev-libs/libtasn1-4.3:=[${MULTILIB_USEDEP}]
	>=dev-libs/nettle-3.1:=[gmp,${MULTILIB_USEDEP}]
	>=dev-libs/gmp-5.1.3-r1:=[${MULTILIB_USEDEP}]
	tools? ( sys-devel/autogen )
	dane? ( >=net-dns/unbound-1.4.20[${MULTILIB_USEDEP}] )
	guile? ( >=dev-scheme/guile-1.8:=[networking] )
	nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )
	pkcs11? ( >=app-crypt/p11-kit-0.23.1[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	idn? ( net-dns/libidn[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	>=sys-devel/automake-1.11.6
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	doc? (
		sys-apps/texinfo
		dev-util/gtk-doc
	)
	nls? ( sys-devel/gettext )
	test? ( app-misc/datefudge )"

pkg_setup() {
	# bug#520818
	export TZ=UTC
}

src_prepare() {
	default

	sed -i \
		-e 's/imagesdir = $(infodir)/imagesdir = $(htmldir)/' \
		doc/Makefile.am || die

	# force regeneration of autogen-ed files
	local file
	for file in $(grep -l AutoGen-ed src/*.c) ; do
		rm src/$(basename ${file} .c).{c,h} || die
	done

	# force regeneration of makeinfo files
	# have no idea why on some system these files are not
	# accepted as-is, see bug#520818
	for file in $(grep -l "produced by makeinfo" doc/*.info) ; do
		rm "${file}" || die
	done

	eautoreconf

	# Use sane .so versioning on FreeBSD.
	elibtoolize

	# bug 497472
	use cxx || epunt_cxx
}

multilib_src_configure() {
	LINGUAS="${LINGUAS//en/en@boldquot en@quot}"

	# remove magic of library detection
	# bug#438222
	libconf=($("${S}/configure" --help | grep -- '--without-.*-prefix' | sed -e 's/^ *\([^ ]*\) .*/\1/g'))

	# TPM needs to be tested before being enabled
	# hardware-accell is disabled on OSX because the asm files force
	#   GNU-stack (as doesn't support that) and when that's removed ld
	#   complains about duplicate symbols
	ECONF_SOURCE=${S} \
	econf \
		--disable-valgrind-tests \
		--without-included-libtasn1 \
		$(use_enable cxx) \
		$(use_enable dane libdane) \
		$(multilib_native_enable manpages) \
		$(multilib_native_use_enable tools) \
		$(multilib_native_use_enable doc) \
		$(multilib_native_use_enable doc gtk-doc) \
		$(multilib_native_use_enable guile) \
		$(multilib_native_use_enable test tests) \
		$(use_enable nls) \
		$(use_enable openssl openssl-compatibility) \
		$(use_enable tls-heartbeat heartbeat-support) \
		$(use_enable sslv2 ssl2-support) \
		$(use_enable sslv3 ssl3-support) \
		$(use_enable static-libs static) \
		$(use_with pkcs11 p11-kit) \
		$(use_with zlib) \
		$(use_with idn) \
		--without-tpm \
		--with-unbound-root-key-file=/etc/dnssec/root-anchors.txt \
		"${libconf[@]}" \
		$([[ ${CHOST} == *-darwin* ]] && echo --disable-hardware-acceleration)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all

	dodoc doc/certtool.cfg

	if use doc; then
		dohtml doc/gnutls.html
	else
		rm -fr "${ED}/usr/share/doc/${PF}/html"
	fi

	if use examples; then
		docinto examples
		dodoc doc/examples/*.c
	fi
}
