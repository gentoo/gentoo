# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..2} luajit )
PYTHON_COMPAT=( python3_{10..12} )

inherit lua-single python-any-r1 scons-utils toolchain-funcs

DESCRIPTION="An elegant, secure, adaptable and intuitive XMPP Client"
HOMEPAGE="https://www.swift.im/"
SRC_URI="
	https://swift.im/git/${PN}/snapshot/${PN}-${P}.tar.bz2 -> ${P}.tar.bz2
	https://dev.gentoo.org/~conikost/distfiles/patches/${P}-python3-compatibility.patch.gz
"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD BSD-1 CC-BY-3.0 GPL-3 OFL-1.1"
SLOT="4/0"
KEYWORDS="amd64"
IUSE="expat +icu +idn lua test zeroconf"
REQUIRED_USE="
	|| ( icu idn )
	lua? ( ${LUA_REQUIRED_USE} )
"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/boost:=
	dev-libs/openssl:0=
	net-libs/libnatpmp
	net-libs/miniupnpc:=
	sys-libs/zlib
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2:2 )
	icu? ( dev-libs/icu:= )
	idn? ( net-dns/libidn:= )
	lua? ( ${LUA_DEPS} )
"

DEPEND="
	${RDEPEND}
	>=dev-build/scons-3.0.1-r3
	test? ( net-dns/avahi )
"

# Tests don't run, as they fail with "[QA/UnitTest/**dummy**] Error -6".
RESTRICT="test"

DOCS=(
	"DEVELOPMENT.md"
	"README.md"
	"Swiften/ChangeLog.md"
)

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.2-boost-1.69-compatibility.patch
	"${FILESDIR}"/${PN}-4.0.2-qt-5.15-compatibility.patch
	"${FILESDIR}"/${PN}-4.0.3-gcc11-compatibility.patch
	"${FILESDIR}"/${PN}-4.0.3-libxml2-2.12-compatibility.patch
	"${WORKDIR}"/${PN}-4.0.3-python3-compatibility.patch
	"${FILESDIR}"/${PN}-4.0.3-reproducible-build.patch
	"${FILESDIR}"/${PN}-4.0.3-miniupnpc.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default

	# Don't include '/usr/lib*' in the link command line for `swiften-config`
	sed -e '/_LIBDIRFLAGS/d' -i Swiften/Config/SConscript || die

	# Use correct LIBDIR for Lua
	sed -e "s/lib/$(get_libdir)/g" -i Sluift/SConscript.variant || die

	# bug #933871
	sed -i -e 's:c++11:c++17:g' BuildTools/SCons/SConscript.boot || die

	# Hack for finding Qt system libs
	mkdir "${T}"/qt || die
	ln -s "${EPREFIX}"/usr/$(get_libdir)/qt5/bin "${T}"/qt/bin || die
	ln -s "${EPREFIX}"/usr/$(get_libdir)/qt5 "${T}"/qt/lib || die
	ln -s "${EPREFIX}"/usr/include/qt5 "${T}"/qt/include || die

	# Remove parts of Swift, which a user don't want to compile
	rm -fr Swift Slimber || die
	if ! use lua; then rm -fr Sluift || die; fi
	if ! use zeroconf; then rm -fr Limber || die; fi

	# Remove '3rdParty', as the system libs should be used
	# `CppUnit`, `GoogleTest` and `HippoMocks` are needed for tests
	local my3rdparty=(
		Boost
		Breakpad
		DocBook
		Expat
		LCov
		Ldns
		LibIDN
		LibMiniUPnPc
		LibNATPMP
		Lua
		OpenSSL
		SCons
		SQLite
		Unbound
		ZLib
	)

	if use test; then
		cd 3rdParty && rm -fr "${my3rdparty[@]}" || die
	else
		rm -fr 3rdParty || die
	fi

	if [[ ! -f VERSION.swift ]] ; then
		# Source tarball from git doesn't include this file
		echo "${PV}" > VERSION.swift || die
	fi
}

src_configure() {
	MYSCONS=(
		ar="$(tc-getAR)"
		allow_warnings="yes"
		assertions="no"
		build_examples="yes"
		boost_bundled_enable="false"
		boost_force_bundled="false"
		cc="$(tc-getCC)"
		ccache="no"
		ccflags="${CFLAGS}"
		coverage="no"
		cxx="$(tc-getCXX)"
		cxxflags="${CXXFLAGS}"
		debug="no"
		distcc="no"
		experimental="no"
		experimental_ft="yes"
		hunspell_enable="no"
		icu="$(usex icu)"
		install_git_hooks="no"
		# Use 'DISABLE' as an invalid lib name, so no editline lib is used,
		# as current version is not compatible and compilation will fail.
		editline_libname="DISABLE"
		libidn_bundled_enable="false"
		libminiupnpc_force_bundled="false"
		libnatpmp_force_bundled="false"
		link="$(tc-getCXX)"
		linkflags="${LDFLAGS}"
		max_jobs="no"
		optimize="no"
		qt="${T}/qt"
		qt5="no"
		swiften_dll="true"
		swift_mobile="no"
		target="native"
		test="none"
		try_avahi="no"
		try_expat="$(usex expat)"
		try_gconf="no"
		try_libidn="$(usex idn)"
		try_libxml="$(usex !expat)"
		tls_backend="openssl"
		unbound="no"
		V="1"
		valgrind="no"
		zlib_bundled_enable="false"
	)

	if use lua; then
		MYSCONS+=(
			lua_includedir="$(lua_get_include_dir)"
			lua_libdir="${EPREFIX}/usr/$(get_libdir)"
			lua_libname="$(basename -s '.so' $(lua_get_shared_lib))"
		)
	fi
}

src_compile() {
	local myesconsinstall=(
		Swiften
		$(usex lua Sluift '')
		$(usex zeroconf Limber '')
	)

	escons "${MYSCONS[@]}" "${myesconsinstall[@]}"
}

src_test() {
	MYSCONS=(
		V="1"
	)

	escons "${MYSCONS[@]}" test=unit QA
}

src_install() {
	local myesconsinstall=(
		SWIFTEN_INSTALLDIR="${ED}/usr"
		SWIFTEN_LIBDIR="${ED}/usr/$(get_libdir)"
		$(usex lua "SLUIFT_DIR=${ED}/usr" '')
		$(usex lua "SLUIFT_INSTALLDIR=${ED}/usr" '')
		"${ED}"
	)

	escons "${MYSCONS[@]}" "${myesconsinstall[@]}"

	use zeroconf && dobin Limber/limber

	einstalldocs
}
