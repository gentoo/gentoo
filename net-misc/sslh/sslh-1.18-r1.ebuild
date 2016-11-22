# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P="${PN}-v${PV}"
inherit flag-o-matic systemd toolchain-funcs

DESCRIPTION="Port multiplexer - accept both HTTPS and SSH connections on the same port"
HOMEPAGE="http://www.rutschle.net/tech/sslh.shtml"
SRC_URI="http://www.rutschle.net/tech/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~m68k ~mips ~s390 ~sh x86"
IUSE="caps systemd tcpd"

RDEPEND="caps? ( sys-libs/libcap )
	systemd? ( sys-apps/systemd:= )
	tcpd? ( sys-apps/tcp-wrappers )
	dev-libs/libconfig"
DEPEND="${RDEPEND}
	dev-lang/perl"

RESTRICT="test"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${PN}-1.18-version-deps.patch"
	"${FILESDIR}/${PN}-1.18-systemd-generator.patch"
)

src_compile() {
	# On older versions of GCC, the default gnu89 variant
	# will reject within-for-loop initializers, bug #595426
	# Furthermore, we need to use the gnu variant (gnu99) instead
	# of the ISO (c99) variant, as we want the __USE_XOPEN2K macro
	# to be defined.
	append-cflags -std=gnu99

	emake \
		CC="$(tc-getCC)" \
		USELIBCAP=$(usev caps) \
		USELIBWRAP=$(usev tcpd) \
		USESYSTEMD=$(usev systemd)
}

src_install() {
	dosbin sslh-{fork,select}
	dosym sslh-fork /usr/sbin/sslh
	doman sslh.8.gz
	dodoc ChangeLog README.md

	newinitd "${FILESDIR}"/sslh.init.d-2 sslh
	newconfd "${FILESDIR}"/sslh.conf.d-2 sslh

	if use systemd; then
		# Gentoo puts the binaries in /usr/sbin, but upstream puts them in /usr/bin
		sed -i -e 's~/usr/bin/~/usr/sbin/~g' scripts/systemd.sslh.service || die
		systemd_newunit scripts/systemd.sslh.service sslh.service
		exeinto /usr/lib/systemd/system-generators/
		doexe systemd-sslh-generator
	fi
}
