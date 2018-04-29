# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils user

DESCRIPTION="An open source instant messaging transport"
HOMEPAGE="https://www.spectrum.im"
SRC_URI="https://github.com/SpectrumIM/spectrum2/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc frotz irc mysql postgres purple sms +sqlite test twitter xmpp"
REQUIRED_USE="|| ( mysql postgres sqlite )"

DEPEND="dev-libs/boost:=
	dev-libs/expat
	dev-libs/log4cxx
	dev-libs/jsoncpp:=
	dev-libs/openssl:0=
	dev-libs/popt
	dev-libs/protobuf:=
	net-dns/libidn
	net-misc/curl
	sys-libs/zlib:=
	doc? ( app-doc/doxygen )
	frotz? ( !games-engines/frotz )
	irc? ( net-im/libcommuni )
	mysql? ( || ( dev-db/mariadb-connector-c dev-db/mysql-connector-c ) )
	postgres? ( dev-db/postgresql:= )
	purple? ( dev-libs/glib
		dev-libs/libev:=
		net-im/pidgin:= )
	sms? ( app-mobilephone/smstools )
	sqlite? ( dev-db/sqlite:3 )
	test? ( dev-util/cppunit )
	twitter? ( net-misc/curl )
	xmpp? ( net-im/swiften[ft]:= )"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/remove_debug_cflags.patch" "${FILESDIR}/use_qt5_libcommuni.patch" )

pkg_setup() {
	enewgroup spectrum
	enewuser spectrum -1 -1 /var/lib/spectrum2 spectrum
}

src_prepare() {
	# Respect users LDFLAGS
	sed -i -e "s/-Wl,-export-dynamic/& ${LDFLAGS}/" spectrum/src/CMakeLists.txt || die

	# Respect users CFLAGS, when compiling for debug mode.
	# Since Spectrum2 searches for a qt4 compiled libcommuni,
	# it must be patched, to find the qt5 compiled libcommuni.
	# See: https://github.com/SpectrumIM/spectrum2/pull/253
	cmake-utils_src_prepare
}

src_configure() {
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	fi

	local mycmakeargs=(
		-DENABLE_DOCS="$(usex doc)"
		-DENABLE_FROTZ="$(usex frotz)"
		-DENABLE_IRC="$(usex irc)"
		-DENABLE_MYSQL="$(usex mysql)"
		-DENABLE_PQXX="$(usex postgres)"
		-DENABLE_PURPLE="$(usex purple)"
		-DENABLE_SMSTOOLS3="$(usex sms)"
		-DENABLE_SQLITE3="$(usex sqlite)"
		-DENABLE_TESTS="$(usex test)"
		-DENABLE_TWITTER="$(usex twitter)"
		-DENABLE_XMPP="$(usex xmpp)"
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	einstalldocs

	keepdir /var/log/spectrum2 /var/lib/spectrum2

	newinitd "${FILESDIR}"/spectrum2.initd spectrum2

	fowners -R spectrum:spectrum /etc/spectrum2 /var/lib/spectrum2 /var/log/spectrum2
}
