# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PV=${PV/_/-}

inherit eutils flag-o-matic java-pkg-opt-2 multilib

PATCHSET_VER="0"

DESCRIPTION="free, small, and standard compliant Prolog compiler"
HOMEPAGE="http://www.swi-prolog.org/"
SRC_URI="http://www.swi-prolog.org/download/stable/src/swipl-${MY_PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="archive berkdb debug doc +gmp hardened java +libedit libressl minimal odbc pcre readline ssl static-libs test uuid zlib X"

RDEPEND="sys-libs/ncurses:=
	archive? ( app-arch/libarchive )
	berkdb? ( >=sys-libs/db-4:= )
	zlib? ( sys-libs/zlib )
	odbc? ( dev-db/unixODBC )
	pcre? ( dev-libs/libpcre )
	readline? ( sys-libs/readline:= )
	libedit? ( dev-libs/libedit )
	gmp? ( dev-libs/gmp:0 )
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)
	java? ( >=virtual/jdk-1.7:= )
	uuid? ( dev-libs/ossp-uuid )
	X? (
		virtual/jpeg:0
		x11-libs/libX11
		x11-libs/libXft
		x11-libs/libXpm
		x11-libs/libXt
		x11-libs/libICE
		x11-libs/libSM )"

DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )
	java? ( test? ( =dev-java/junit-3.8* ) )"

S="${WORKDIR}/swipl-${MY_PV}"

src_prepare() {
	EPATCH_FORCE=yes
	EPATCH_SUFFIX=patch
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		epatch "${WORKDIR}"/${PV}
	fi

	if ! use uuid; then
		mv packages/clib/uuid.pl packages/clib/uuid.pl.unused || die
	fi

	# OSX/Intel ld doesn't like an archive without table of contents
	sed -i -e 's/-cru/-scru/' packages/nlp/libstemmer_c/Makefile.pl || die
}

src_configure() {
	append-flags -fno-strict-aliasing
	use ppc && append-flags -mno-altivec
	use hardened && append-flags -fno-unit-at-a-time
	use debug && append-flags -DO_DEBUG

	# ARCH is used in the configure script to figure out host and target
	# specific stuff
	export ARCH=${CHOST}

	export CC_FOR_BUILD=$(tc-getBUILD_CC)

	cd "${S}"/src || die
	econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		$(use_enable gmp) \
		$(use_enable static-libs static) \
		--enable-shared \
		--enable-custom-flags COFLAGS="${CFLAGS}"

	if ! use minimal ; then
		local jpltestconf
		if use java && use test ; then
			jpltestconf="--with-junit=$(java-config --classpath junit)"
		fi

		cd "${S}/packages" || die
		econf \
			--libdir="${EPREFIX}"/usr/$(get_libdir) \
			$(use_with archive) \
			$(use_with berkdb bdb ) \
			$(use_with java jpl) \
			${jpltestconf} \
			$(use_with libedit) \
			$(use_with pcre) \
			$(use_with odbc) \
			$(use_with readline) \
			$(use_with ssl) \
			$(use_with X xpce) \
			$(use_with zlib) \
			COFLAGS='"${CFLAGS}"'
	fi
}

src_compile() {
	cd "${S}"/src || die
	emake

	if ! use minimal ; then
		cd "${S}/packages" || die
		emake
		./report-failed || die "Cannot report failed packages"
	fi
}

src_test() {
	cd "${S}/src" || die
	emake check

	if ! use minimal ; then
		unset DISPLAY
		cd "${S}/packages" || die
		emake \
			USE_PUBLIC_NETWORK_TESTS=false \
			USE_ODBC_TESTS=false \
			check
		./report-failed || die
	fi
}

src_install() {
	emake -C src DESTDIR="${D}" install

	if ! use minimal ; then
		emake -C packages DESTDIR="${D}" install
		if use doc ; then
			emake -C packages DESTDIR="${D}" html-install
		fi
		./packages/report-failed || die "Cannot report failed packages"
	fi

	dodoc ReleaseNotes/relnotes-5.10 INSTALL README.md VERSION
}
