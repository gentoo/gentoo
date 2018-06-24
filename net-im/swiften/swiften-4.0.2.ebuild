# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit scons-utils toolchain-funcs

DESCRIPTION="A C++ library for implementing XMPP applications"
HOMEPAGE="https://www.swift.im/"
SRC_URI="https://swift.im/downloads/releases/swift-${PV}/swift-${PV}.tar.gz"

LICENSE="BSD BSD-1 CC-BY-3.0 GPL-3 OFL-1.1"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"
IUSE="expat experimental ft icu idn zeroconf"
REQUIRED_USE="ft? ( experimental )"

RDEPEND="dev-libs/boost:=
	dev-libs/openssl:0=
	sys-libs/zlib:=
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2:2 )
	experimental? ( dev-db/sqlite:3 )
	ft? (   net-libs/libnatpmp
		net-libs/miniupnpc:= )
	icu? ( dev-libs/icu:= )
	idn? ( net-dns/libidn )
	zeroconf? ( net-dns/avahi )"

DEPEND=">=dev-util/scons-3.0.1-r1
	${RDEPEND}"

S="${WORKDIR}/swift-${PV}"

DOCS=( "DEVELOPMENT.md" "README.md" "Swiften/ChangeLog.md" )

src_prepare() {
	default

	# Remove '3rdParty', as the system libs should be used
	# Remove 'Limber', 'Slimber' and 'Sluift', as we compile only libSwiften
	rm -fr 3rdParty Limber Slimber Sluift || die
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
		experimental="$(usex experimental)"
		experimental_ft="$(usex ft)"
		hunspell_enable="false"
		icu="$(usex icu)"
		install_git_hooks="no"
		libidn_bundled_enable="false"
		libminiupnpc_force_bundled="false"
		libnatpmp_force_bundled="false"
		link="$(tc-getCXX)"
		linkflags="${LDFLAGS}"
		lua_force_bundled="false"
		max_jobs="no"
		optimize="no"
		qt5="false"
		swiften_dll="true"
		swift_mobile="no"
		target="native"
		test="none"
		try_avahi="$(usex zeroconf)"
		try_expat="$(usex expat)"
		try_gconf="false"
		try_libidn="$(usex idn)"
		try_libxml="$(usex expat no yes)"
		tls_backend="openssl"
		unbound="no"
		valgrind="no"
		zlib_bundled_enable="false"
		Swiften
	)
}

src_compile() {
	escons V=1 "${MYSCONS[@]}" PROJECTS="Swiften" Swiften
}

src_install() {
	escons "${MYSCONS[@]}" SWIFTEN_INSTALLDIR="${ED%/}/usr" SWIFTEN_LIBDIR="${ED%/}/usr/$(get_libdir)" "${ED%/}/usr" Swiften
	einstalldocs
}
