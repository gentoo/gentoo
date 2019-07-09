# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils scons-utils toolchain-funcs

DESCRIPTION="An elegant, secure, adaptable and intuitive XMPP Client"
HOMEPAGE="https://www.swift.im/"
SRC_URI="https://swift.im/downloads/releases/${P}/${P}.tar.gz"

LICENSE="BSD BSD-1 CC-BY-3.0 GPL-3 OFL-1.1"
SLOT="4/0"
KEYWORDS="amd64"
IUSE="client expat gconf +icu +idn lua spell test zeroconf"
REQUIRED_USE="
	|| ( icu idn )
	gconf? ( client )
	spell? ( client )
"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/boost:=
	dev-libs/openssl:0=
	net-libs/libnatpmp
	net-libs/miniupnpc:=
	sys-libs/zlib:=
	client? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtwebkit:5
		dev-qt/qtx11extras:5
		net-dns/avahi
	)
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2:2 )
	gconf? ( gnome-base/gconf:2 )
	icu? ( dev-libs/icu:= )
	idn? ( net-dns/libidn:= )
	lua? ( dev-lang/lua:= )
	spell? ( app-text/hunspell:= )
"

DEPEND="
	${RDEPEND}
	>=dev-util/scons-3.0.1-r3
	client? ( dev-qt/linguist-tools:5 )
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
	"${FILESDIR}"/${P}-boost-1.69-compatibility.patch
	"${FILESDIR}"/${P}-make-generated-files-handle-unicode-characters.patch
	"${FILESDIR}"/${P}-qt-5.11-compatibility.patch
)

src_prepare() {
	default

	# Hack for finding Qt system libs
	mkdir "${T}"/qt || die
	ln -s "${EPREFIX%/}"/usr/$(get_libdir)/qt5/bin "${T}"/qt/bin || die
	ln -s "${EPREFIX%/}"/usr/$(get_libdir)/qt5 "${T}"/qt/lib || die
	ln -s "${EPREFIX%/}"/usr/include/qt5 "${T}"/qt/include || die

	# Remove parts of Swift, which a user don't want to compile
	if ! use client; then rm -fr Swift Slimber || die; fi
	if ! use lua; then rm -fr Sluift || die; fi
	if ! use zeroconf; then
		rm -fr Limber || die
		if use client; then rm -fr Slimber || die; fi
	fi

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
		hunspell_enable="$(usex spell)"
		icu="$(usex icu)"
		install_git_hooks="no"
		libidn_bundled_enable="false"
		libminiupnpc_force_bundled="false"
		libnatpmp_force_bundled="false"
		link="$(tc-getCXX)"
		linkflags="${LDFLAGS}"
		max_jobs="no"
		optimize="no"
		qt="${T}/qt"
		qt5="$(usex client)"
		swiften_dll="true"
		swift_mobile="no"
		target="native"
		test="none"
		try_avahi="$(usex client)"
		try_expat="$(usex expat)"
		try_gconf="$(usex gconf)"
		try_libidn="$(usex idn)"
		try_libxml="$(usex !expat)"
		tls_backend="openssl"
		unbound="no"
		V="1"
		valgrind="no"
		zlib_bundled_enable="false"
	)
}

src_compile() {
	local myesconsinstall=(
		Swiften
		$(usex client Swift '')
		$(usex lua Sluift '')
		$(usex zeroconf Limber '')
		$(usex zeroconf "$(usex client Slimber '')" '')
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
		SWIFTEN_INSTALLDIR="${ED%/}/usr"
		SWIFTEN_LIBDIR="${ED%/}/usr/$(get_libdir)"
		$(usex client "SWIFT_INSTALLDIR=${ED%/}/usr" '')
		$(usex lua "SLUIFT_DIR=${ED%/}/usr" '')
		$(usex lua "SLUIFT_INSTALLDIR=${ED%/}/usr" '')
		"${ED}"
	)

	escons "${MYSCONS[@]}" "${myesconsinstall[@]}"

	use zeroconf && dobin Limber/limber
	use zeroconf && use client && newbin Slimber/CLI/slimber slimber-cli
	use zeroconf && use client && newbin Slimber/Qt/slimber slimber-qt

	einstalldocs
}

pkg_postinst() {
	use client && gnome2_icon_cache_update
}

pkg_postrm() {
	use client && gnome2_icon_cache_update
}
