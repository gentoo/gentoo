# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd tmpfiles

DESCRIPTION="An open source instant messaging transport"
HOMEPAGE="https://www.spectrum.im"
SRC_URI="https://github.com/SpectrumIM/spectrum2/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc frotz irc mysql postgres purple sms +sqlite test twitter whatsapp xmpp"
REQUIRED_USE="
	|| ( mysql postgres sqlite )
	test? ( irc )
"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/spectrum
	acct-user/spectrum
	dev-libs/boost:=[nls]
	dev-libs/expat
	dev-libs/libev:=
	>=dev-libs/log4cxx-1.0.0:=
	dev-libs/jsoncpp:=
	dev-libs/openssl:=
	dev-libs/popt
	dev-libs/protobuf:=
	net-dns/libidn:=
	>=net-im/swift-4.0.2-r2:=
	net-misc/curl
	sys-libs/zlib:=
	frotz? ( !games-engines/frotz )
	irc? ( net-im/libcommuni )
	mysql? (
		|| (
			dev-db/mariadb-connector-c
			dev-db/mysql-connector-c
		)
	)
	postgres? ( dev-libs/libpqxx:= )
	purple? (
		dev-libs/glib
		net-im/pidgin:=
	)
	sms? ( app-mobilephone/smstools )
	sqlite? ( dev-db/sqlite:3 )
	twitter? ( net-misc/curl )
	whatsapp? ( net-im/transwhat )"

DEPEND="
	${RDEPEND}
	doc? ( app-text/doxygen )
	test? ( dev-util/cppunit )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-boost-1.85.patch
	"${FILESDIR}"/${PN}-2.2.1-use-c++14.patch
)

src_prepare() {
	# Respect users LDFLAGS
	sed -i -e "s/-Wl,-export-dynamic/& ${LDFLAGS}/" spectrum/src/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LOCALSTATEDIR="${EPREFIX}/var"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DENABLE_DOCS="$(usex doc)"
		-DENABLE_FROTZ="$(usex frotz)"
		-DENABLE_IRC="$(usex irc)"
		-DENABLE_MYSQL="$(usex mysql)"
		-DENABLE_PQXX="$(usex postgres)"
		-DENABLE_PURPLE="$(usex purple)"
		$(usex irc '-DENABLE_QT4=OFF' '')
		-DENABLE_SMSTOOLS3="$(usex sms)"
		-DENABLE_SQLITE3="$(usex sqlite)"
		-DENABLE_TESTS="$(usex test)"
		-DENABLE_TWITTER="$(usex twitter)"
		-DENABLE_XMPP="$(usex xmpp)"
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}/tests/libtransport" || die
	./libtransport_test || die
}

src_install() {
	cmake_src_install

	diropts -o spectrum -g spectrum
	keepdir /var/log/spectrum2 /var/lib/spectrum2
	diropts

	newinitd "${FILESDIR}"/spectrum2.initd spectrum2
	systemd_newunit "${FILESDIR}"/spectrum2.service spectrum2.service
	newtmpfiles "${FILESDIR}"/spectrum2.tmpfiles-r1 spectrum2.conf

	einstalldocs
}

pkg_postinst() {
	tmpfiles_process spectrum2.conf

	if [[ ${REPLACING_VERSIONS} ]]; then
		for v in ${REPLACING_VERSIONS}; do
			if ver_test "${v}" -lt 2.2.0; then
				ewarn "Starting with Release 2.2.0, the path for spectrum2"
				ewarn "executable helper files has been changed from '/usr/bin'"
				ewarn "to '/usr/libexec'. Please update your config files!"
				break
			fi
		done
	fi
}
