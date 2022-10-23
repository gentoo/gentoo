# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-3 )
LUA_REQ_USE="deprecated"
PYTHON_COMPAT=( python3_{8..11} )
inherit autotools lua-single python-any-r1 toolchain-funcs

DESCRIPTION="Network exploration tool and security / port scanner"
HOMEPAGE="https://nmap.org/"
if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/nmap/nmap"

else
	VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/nmap.asc
	inherit verify-sig

	SRC_URI="https://nmap.org/dist/${P}.tar.bz2"
	SRC_URI+=" verify-sig? ( https://nmap.org/dist/sigs/${P}.tar.bz2.asc )"

	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

LICENSE="|| ( NPSL GPL-2 )"
SLOT="0"
IUSE="ipv6 libssh2 ncat nping +nse ssl symlink +system-lua"
REQUIRED_USE="
	system-lua? ( nse ${LUA_REQUIRED_USE} )
	symlink? ( ncat )
"

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
	symlink? (
		ncat? (
			!net-analyzer/netcat
			!net-analyzer/openbsd-netcat
		)
	)
	system-lua? ( ${LUA_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-nmap )"
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
	"${FILESDIR}"/${P}-openssl-1.1.patch
	"${FILESDIR}"/${PN}-9999-netutil-else.patch
)

pkg_setup() {
	python-any-r1_pkg_setup

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
		# We need the original for a Darwin-specific fix, bug #604432
		mv libdnet-stripped/include/config.h.in{.nmap-orig,} || die
	fi
}

src_configure() {
	export ac_cv_path_PYTHON="${PYTHON}"
	export am_cv_pathless_PYTHON="${EPYTHON}"

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
		--without-dpdk \
		--without-ndiff \
		--without-zenmap
}

src_compile() {
	local directory
	for directory in . libnetutil nsock/src $(usev ncat) $(usev nping) ; do
		emake -C "${directory}" makefile.dep
	done

	emake \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)"
}

src_install() {
	# See bug #831713 for return of -j1
	LC_ALL=C emake \
		-j1 \
		DESTDIR="${D}" \
		STRIP=: \
		nmapdatadir="${EPREFIX}"/usr/share/nmap \
		install

	dodoc CHANGELOG HACKING docs/README docs/*.txt

	use symlink && dosym /usr/bin/ncat /usr/bin/nc
}
