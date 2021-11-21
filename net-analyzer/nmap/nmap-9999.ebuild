# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-3 )
LUA_REQ_USE="deprecated"
inherit autotools lua-single toolchain-funcs

DESCRIPTION="Network exploration tool and security / port scanner"
HOMEPAGE="https://nmap.org/"
if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/nmap/nmap"

	# Just in case for now as future seems undecided.
	LICENSE="NPSL"
else
	VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/nmap.asc
	inherit verify-sig

	SRC_URI="https://nmap.org/dist/${P}.tar.bz2"
	SRC_URI+=" verify-sig? ( https://nmap.org/dist/sigs/${P}.tar.bz2.asc )"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

	LICENSE="|| ( NPSL GPL-2 )"
fi

SLOT="0"
IUSE="ipv6 libssh2 ncat nping +nse ssl +system-lua"
REQUIRED_USE="system-lua? ( nse ${LUA_REQUIRED_USE} )"

RDEPEND="
	dev-libs/liblinear:=
	dev-libs/libpcre
	net-libs/libpcap
	libssh2? (
		net-libs/libssh2[zlib]
		sys-libs/zlib
	)
	nse? ( sys-libs/zlib )
	ssl? ( dev-libs/openssl:0= )
	system-lua? ( ${LUA_DEPS} )
"
DEPEND="${RDEPEND}"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND+="verify-sig? ( app-crypt/openpgp-keys-nmap )"
fi

PATCHES=(
	"${FILESDIR}"/${PN}-5.10_beta1-string.patch
	"${FILESDIR}"/${PN}-5.21-python.patch
	"${FILESDIR}"/${PN}-6.46-uninstaller.patch
	"${FILESDIR}"/${PN}-6.25-liblua-ar.patch
	"${FILESDIR}"/${PN}-7.25-CXXFLAGS.patch
	"${FILESDIR}"/${PN}-7.25-libpcre.patch
	"${FILESDIR}"/${PN}-7.31-libnl.patch
	"${FILESDIR}"/${PN}-7.80-ac-config-subdirs.patch
	"${FILESDIR}"/${PN}-7.91-no-FORTIFY_SOURCE.patch
	"${FILESDIR}"/${PN}-9999-netutil-else.patch
)

pkg_setup() {
	use system-lua && lua-single_pkg_setup
}

src_prepare() {
	rm -r liblinear/ libpcap/ libpcre/ libssh2/ libz/ || die

	cat "${FILESDIR}"/nls.m4 >> "${S}"/acinclude.m4 || die

	default

	sed -i \
		-e '/^ALL_LINGUAS =/{s|$| id|g;s|jp|ja|g}' \
		Makefile.in || die

	cp libdnet-stripped/include/config.h.in{,.nmap-orig} || die

	eautoreconf

	if [[ ${CHOST} == *-darwin* ]] ; then
		# we need the original for a Darwin-specific fix, bug #604432
		mv libdnet-stripped/include/config.h.in{.nmap-orig,} || die
	fi
}

src_configure() {
	# The bundled libdnet is incompatible with the version available in the
	# tree, so we cannot use the system library here.
	econf \
		$(use_enable ipv6) \
		$(use_with libssh2) \
		$(use_with ncat) \
		$(use_with nping) \
		$(use_with ssl openssl) \
		$(usex libssh2 --with-zlib) \
		$(usex nse --with-liblua=$(usex system-lua yes included '' '') --without-liblua) \
		$(usex nse --with-zlib) \
		--cache-file="${S}"/config.cache \
		--with-libdnet=included \
		--with-pcre="${ESYSROOT}"/usr \
		--without-ndiff \
		--without-zenmap
}

src_compile() {
	local directory
	for directory in . libnetutil nsock/src \
		$(usex ncat ncat '') \
		$(usex nping nping '')
	do
		emake -C "${directory}" makefile.dep
	done

	emake \
		AR=$(tc-getAR) \
		RANLIB=$(tc-getRANLIB)
}

src_install() {
	LC_ALL=C emake \
		DESTDIR="${D}" \
		STRIP=: \
		nmapdatadir="${EPREFIX}"/usr/share/nmap \
		install

	dodoc CHANGELOG HACKING docs/README docs/*.txt
}
