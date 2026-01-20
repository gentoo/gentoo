# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="XMPP gateway to IRC"
HOMEPAGE="https://biboumi.codeberg.page"
SRC_URI="
	https://codeberg.org/poezio/biboumi/archive/bf958d0e34e7d8a39dccfcf3c64f72ef0db41f73.tar.gz
		-> ${P}.tar.gz
"

S="${WORKDIR}/${PN}"
LICENSE="ZLIB"
SLOT="0"

KEYWORDS="~amd64"

IUSE="+idn postgres +sqlite +ssl systemd test udns"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/expat
	virtual/libiconv
	sys-apps/util-linux
	sqlite? ( dev-db/sqlite:3 )
	postgres? ( dev-db/postgresql:* )
	idn? ( net-dns/libidn:= )
	udns? ( net-libs/udns )
	ssl? ( dev-libs/botan:3= )
	!ssl? ( dev-libs/libgcrypt )
	systemd? ( sys-apps/systemd:= )
"
DEPEND="
	${COMMON_DEPEND}
	test? ( >=dev-cpp/catch-3 )
"
BDEPEND="dev-python/sphinx"
RDEPEND="
	${COMMON_DEPEND}
	acct-user/biboumi
"

DOCS=( README.rst CHANGELOG.rst doc/user.rst )

src_configure() {
	local mycmakeargs=(
		-DSERVICE_USER="${PN}"
		-DSERVICE_GROUP="${PN}"
	)

	# Account for biboumi's atypical configuration system.
	if use systemd; then
		mycmakeargs+=(-DWITH_SYSTEMD=yes)
	else
		mycmakeargs+=(-DWITHOUT_SYSTEMD=yes)
	fi

	if use idn; then
		mycmakeargs+=(-DWITH_LIBIDN=yes)
	else
		mycmakeargs+=(-DWITHOUT_LIBIDN=yes)
	fi

	if use ssl; then
		mycmakeargs+=(-DWITH_BOTAN=yes)
	else
		mycmakeargs+=(-DWITHOUT_BOTAN=yes)
	fi

	if use udns; then
		mycmakeargs+=(-DWITH_UDNS=yes)
	else
		mycmakeargs+=(-DWITHOUT_UDNS=yes)
	fi

	if use sqlite; then
		mycmakeargs+=(-DWITH_SQLITE3=yes)
	else
		mycmakeargs+=(-DWITHOUT_SQLITE3=yes)
	fi

	if use postgres; then
		mycmakeargs+=(-DWITH_POSTGRESQL=yes)
	else
		mycmakeargs+=(-DWITHOUT_POSTGRESQL=yes)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	cmake_build man
}

src_test() {
	cmake_build check
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"

	diropts --owner=biboumi --group=biboumi --mode=750
	if use sqlite; then
		keepdir /var/lib/biboumi
	fi
	keepdir /var/log/biboumi

	insinto /etc/biboumi
	insopts --group=biboumi --mode=640
	newins conf/biboumi.cfg biboumi.cfg.example
}
