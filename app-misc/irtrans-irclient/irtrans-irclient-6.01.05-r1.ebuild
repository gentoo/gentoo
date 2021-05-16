# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

RESTRICT="strip"

DESCRIPTION="ASCII Client for the IRTrans Server"
HOMEPAGE="http://www.irtrans.de"
SRC_URI="http://www.irtrans.de/download/Client/irclient-src.tar.gz -> irclient-src-${PV}.tar.gz
	http://ftp.disconnected-by-peer.at/irtrans/${PN}-5.11.04-ip_assign-1.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

S="${WORKDIR}"

PATCHES=( "${WORKDIR}/${PN}"-5.11.04-ip_assign-1.patch )

src_compile() {
	append-flags -DLINUX

	# Set sane defaults (arm target has no -D flags added)
	local irbuild
	local ipbuild
	irclient=irclient
	ip_assign=ip_assign

	# change variable by need
	if use amd64; then
		irbuild=irclient64
		irclient=irclient64
		ipbuild=ip_assign64
		ip_assign=ip_assign64
	elif use arm; then
		irbuild=irclient_arm
		ipbuild=ip_assign_arm
	elif use x86; then
		irbuild=irclient
		ipbuild=ip_assign
	fi

	emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CXXFLAGS="${CXXFLAGS}" \
		"${irbuild}"
	emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CXXFLAGS="${CXXFLAGS}" \
		"${ipbuild}"
}

src_install() {
	newbin "${irclient}" irclient
	newbin "${ip_assign}" ip_assign
}
