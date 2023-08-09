# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-4 )
LUA_REQ_USE="deprecated"
PYTHON_COMPAT=( python3_{10..11} )
PLOCALES="de es fr hi hr hu id it ja pl pt_BR pt_PR ro ru sk zh"
PLOCALE_BACKUP="en"
inherit autotools lua-single plocale python-single-r1 toolchain-funcs

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

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-7.95-patches.tar.xz"

# https://github.com/nmap/nmap/issues/2199
LICENSE="NPSL-0.95"
SLOT="0"
IUSE="ipv6 libssh2 ncat ndiff nping nls +nse ssl symlink zenmap"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	nse? ( ${LUA_REQUIRED_USE} )
	symlink? ( ncat )
"

RDEPEND="
	dev-libs/liblinear:=
	dev-libs/libpcre2
	net-libs/libpcap
	ndiff? ( ${PYTHON_DEPS} )
	libssh2? (
		net-libs/libssh2[zlib]
		sys-libs/zlib
	)
	nls? ( virtual/libintl )
	nse? (
		${LUA_DEPS}
		sys-libs/zlib
	)
	ssl? ( dev-libs/openssl:= )
	symlink? (
		ncat? (
			!net-analyzer/netcat
			!net-analyzer/openbsd-netcat
		)
	)
	zenmap? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}"
# Python is always needed at build time for some scripts
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-nmap )"
fi

PATCHES=(
	"${WORKDIR}"/${PN}-7.95-patches
)

pkg_setup() {
	python-single-r1_pkg_setup

	use nse && lua-single_pkg_setup
}

src_unpack() {
	if [[ ${PV} == *9999 ]] ; then
		git-r3_src_unpack
	elif use verify-sig ; then
		# Needed for downloaded patch (which is unsigned, which is fine)
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.bz2{,.asc}
	fi

	default
}

src_prepare() {
	default

	# Drop bundled libraries
	rm -r liblinear/ libpcap/ libpcre/ libssh2/ libz/ || die

	cat "${FILESDIR}"/nls.m4 >> "${S}"/acinclude.m4 || die

	delete_disabled_locale() {
		# Force here as PLOCALES contains supported locales for man
		# pages and zenmap doesn't have all of those
		rm -rf zenmap/share/zenmap/locale/${1} || die
		rm -f zenmap/share/zenmap/locale/${1}.po || die
	}
	plocale_for_each_disabled_locale delete_disabled_locale

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

	local myeconfargs=(
		$(use_enable ipv6)
		$(use_enable nls)
		$(use_with libssh2)
		$(use_with ncat)
		$(use_with ndiff)
		$(use_with nping)
		$(use_with nse liblua)
		$(use_with ssl openssl)
		$(use_with zenmap)
		$(usex libssh2 --with-zlib)
		$(usex nse --with-zlib)
		--cache-file="${S}"/config.cache
		# The bundled libdnet is incompatible with the version available in the
		# tree, so we cannot use the system library here.
		--with-libdnet=included
		--with-pcre="${ESYSROOT}"/usr
		--without-dpdk
	)

	econf "${myeconfargs[@]}"
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

	if use ndiff || use zenmap ; then
		python_optimize
	fi

	use symlink && dosym /usr/bin/ncat /usr/bin/nc
}
