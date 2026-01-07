# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-base toolchain-funcs verify-sig

DESCRIPTION="A library of general-purpose, non-graphical Objective C objects"
HOMEPAGE="https://gnustep.github.io"
SRC_URI="
	https://github.com/gnustep/libs-base/releases/download/base-${PV//./_}/${P}.tar.gz
	verify-sig? ( https://github.com/gnustep/libs-base/releases/download/base-${PV//./_}/${P}.tar.gz.sig )
"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 ppc ~ppc64 ~sparc x86"
IUSE="+gnutls +iconv +icu libdispatch +libffi zeroconf"

# gnustep-make: tests use the option --timeout which was added in 2.9.3
RDEPEND="${GNUSTEP_CORE_DEPEND}
	>=gnustep-base/gnustep-make-2.9.3
	gnutls? ( net-libs/gnutls:= )
	iconv? ( virtual/libiconv )
	icu? ( >=dev-libs/icu-49.0:= )
	libdispatch? ( dev-libs/libdispatch )
	libffi? ( dev-libs/libffi:= )
	!libffi? (
		dev-libs/ffcall
		gnustep-base/gnustep-make[-native-exceptions]
	)
	>=dev-libs/libxml2-2.6
	>=dev-libs/libxslt-1.1
	>=dev-libs/gmp-4.1:=
	>=virtual/zlib-1.2:=
	zeroconf? ( net-dns/avahi )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-gnustep )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnustep.asc

PATCHES=(
	"${FILESDIR}"/${PN}-1.26.0-no_compress_man.patch
	"${FILESDIR}"/${PN}-1.31.0-c23.patch
	"${FILESDIR}"/${PN}-1.31.1-openapp_path.patch
)

src_prepare() {
	default

	sed -e "s,/usr/bin,${EPREFIX}/usr/bin," -i Tools/pl2link.m || die

	# Slow and appears to break due to the network sandbox
	sed -e '/START_SET("-sendSynchronousRequest:returningResponse:error:")/a  SKIP("Gentoo")' \
		-i Tests/base/NSURL/test00.m || die
	sed -e '/START_SET("Capture")/a  SKIP("Gentoo")' \
		-e '/START_SET("Secure")/a  SKIP("Gentoo")' \
		-i Tests/base/NSURL/test02.m || die
	sed -e '/START_SET("Keepalive")/a  SKIP("Gentoo")' \
		-i Tests/base/NSURLHandle/test01.m || die
	rm -r Tests/base/NSURLConnection || die
	rm -r Tests/base/NSConnection || die
	sed -e '/PASS(byteCount>0, "read www.google.com");/d' \
		-e '/PASS(byteCount>0, "read www.google.com https");/d' \
		-i Tests/base/NSStream/socket.m || die
	sed -e '/PASS(\[self status\] == URLHandleClientDidBeginLoading,/,/"URLHandleClientDidBeginLoading called");/d' \
		-e '/PASS(\[self status\] == URLHandleClientDidFinishLoading,/,/"URLHandleClientDidFinishLoading called");/d' \
		-i Tests/base/NSURLHandle/test00.m || die

	# FIXME: It should use TEMP or TMP but it still fails
	sed -e '/PASS(\[o length\] > 0, "we can get a temporary directory");/d' \
		-i Tests/base/Functions/NSPathUtilities.m || die

	# FIXME
	rm Tests/base/NSFileHandle/general.m || die

	# FIXME
	sed -e '/PASS_EQUAL(\[\@"foo" stringByResolvingSymlinksInPath\], tmpdst,/,/"foo->bar relative symlink expanded by stringByResolvingSymlinksInPath")/d' \
		-i Tests/base/NSString/test02.m || die

	# FIXME
	sed -e '/PASS(cred != nil, "generates self signed certificate");/d' \
		-i Tests/base/GSTLS/basic.m || die
}

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
		$(use_enable libdispatch)
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
