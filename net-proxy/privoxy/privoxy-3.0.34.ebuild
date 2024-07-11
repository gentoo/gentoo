# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd toolchain-funcs

[ "${PV##*_}" = "beta" ] &&
	PRIVOXY_STATUS="beta" ||
	PRIVOXY_STATUS="stable"

DESCRIPTION="A web proxy with advanced filtering capabilities for enhancing privacy"
HOMEPAGE="https://www.privoxy.org https://sourceforge.net/projects/ijbswa/"
SRC_URI="https://downloads.sourceforge.net/ijbswa/${P%_*}-${PRIVOXY_STATUS}-src.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~ppc ppc64 ~riscv sparc x86"
IUSE="+acl brotli client-tags compression editor extended-host-patterns
extended-statistics external-filters +fast-redirects +force fuzz
graceful-termination +image-blocking ipv6 +jit lfs +mbedtls openssl
png-images sanitize selinux ssl +stats +threads toggle tools whitelists
+zlib"

DEPEND="
	acct-group/privoxy
	acct-user/privoxy
	dev-libs/libpcre
	brotli? ( app-arch/brotli )
	ssl? (
		mbedtls? ( net-libs/mbedtls:= )
		openssl? ( dev-libs/openssl:= )
	)
	zlib? ( sys-libs/zlib:= )
"
RDEPEND="${DEPEND}
	extended-host-patterns? ( dev-lang/perl )
	selinux? ( sec-policy/selinux-privoxy )
	tools? (
		net-misc/curl
		dev-lang/perl
	)
"
REQUIRED_USE="
	brotli? ( zlib )
	client-tags? ( threads )
	compression? ( zlib )
	extended-statistics? ( threads )
	fuzz? ( zlib )
	ssl? ( ^^ ( mbedtls openssl ) threads )
	toggle? ( editor )
"

S="${WORKDIR}/${P%_*}-${PRIVOXY_STATUS}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.32-gentoo.patch
	"${FILESDIR}"/${PN}-3.0.28-strip.patch
	"${FILESDIR}"/${PN}-3.0.33-configure-c99.patch
)

pkg_pretend() {
	if ! use threads; then
		ewarn
		ewarn "Privoxy may be very slow without threads support, consider enabling it."
		ewarn "See also https://www.privoxy.org/faq/trouble.html#GENTOO-RICERS"
		ewarn "Additionally some features may not build or work poperly. You are on your own."
		ewarn
	fi
}

src_prepare() {
	default
	mv configure.in configure.ac || die
	sed -i "s|/p\.p/|/config.privoxy.org/|g" tools/privoxy-regression-test.pl || die

	# autoreconf needs to be called even if we don't modify any autotools source files
	# See main makefile
	eautoreconf
}

src_configure() {
	local myconf="--without-mbedtls --without-openssl"
	if use ssl; then
		myconf="$(use_with mbedtls) $(use_with openssl)"
	fi
	if use sanitize; then
		myconf+=" --with-usan"
		# msan is available in clang only
		# asan is broken with current configure tests in gcc
		tc-is-clang && myconf+=" --with-msan --with-asan"
	fi

	# --with-debug only enables debug CFLAGS
	# --with-docbook and --with-db2html and their deps are useless,
	#	since docs are already pregenerated in the source tarball
	econf \
		--sysconfdir=/etc/privoxy \
		--disable-accept-filter \
		--enable-dynamic-pcre \
		--without-assertions \
		--with-user=privoxy \
		--with-group=privoxy \
		$(use_enable acl acl-support) \
		$(use_enable compression) \
		$(use_enable client-tags) \
		$(use_enable editor) \
		$(use_enable extended-host-patterns pcre-host-patterns) \
		$(use_enable extended-statistics) \
		$(use_enable fast-redirects) \
		$(use_enable force) \
		$(use_enable fuzz) \
		$(use_enable graceful-termination) \
		$(use_enable image-blocking) \
		$(use_enable jit pcre-jit-compilation) \
		$(use_enable ipv6 ipv6-support) \
		$(use_enable lfs large-file-support) \
		$(use_enable png-images no-gifs) \
		$(use_enable stats) \
		$(use_enable threads pthread) \
		$(use_enable toggle) \
		$(use_enable whitelists trust-files) \
		$(use_enable zlib) \
		$(use_with brotli) \
		${myconf}
}

src_install() {
	default

	newinitd "${FILESDIR}/privoxy.initd-3" privoxy
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc/logrotate.d
	newins "${FILESDIR}/privoxy.logrotate" privoxy

	diropts -m 0750 -g privoxy -o privoxy
	keepdir /var/log/privoxy

	use extended-host-patterns && newbin tools/url-pattern-translator.pl privoxy-url-pattern-translator.pl
	if use tools; then
		dobin tools/{privoxy-log-parser.pl,privoxy-regression-test.pl}
		newbin tools/uagen.pl privoxy-uagen.pl
	fi

	rmdir "${ED}/var/run" || die
	chown privoxy:root "${ED}/etc/privoxy" || die
}

pkg_postinst() {
	if use extended-host-patterns; then
		ewarn
		ewarn "You enabled extended-host-patterns, now you *must* convert all action files in"
		ewarn "PCRE-compatible format, or privoxy will fail to start. Helper tool"
		ewarn "privoxy-url-pattern-translator.pl is available."
		ewarn
	fi
}
