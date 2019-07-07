# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic systemd toolchain-funcs

DESCRIPTION="Port multiplexer - accept both HTTPS and SSH connections on the same port"
HOMEPAGE="https://www.rutschle.net/tech/sslh/README.html"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/yrutschle/sslh.git"
	inherit git-r3
else
	KEYWORDS="amd64 ~arm ~m68k ~mips ~s390 ~sh x86"
	MY_P="${PN}-v${PV}"
	SRC_URI="https://www.rutschle.net/tech/${PN}/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="caps pcre systemd tcpd"

RDEPEND="caps? ( sys-libs/libcap )
	systemd? ( sys-apps/systemd:= )
	tcpd? ( sys-apps/tcp-wrappers )
	>=dev-libs/libconfig-1.5"
DEPEND="${RDEPEND}
	dev-lang/perl
	pcre? ( dev-libs/libpcre:= )"

RESTRICT="test"

src_prepare() {
	default
	sed -i \
		-e '/MAN/s:| gzip -9 - >:>:' \
		-e '/MAN=sslh.8.gz/s:.gz::' \
		Makefile || die
}

src_compile() {
	# On older versions of GCC, the default gnu89 variant
	# will reject within-for-loop initializers, bug #595426
	# Furthermore, we need to use the gnu variant (gnu99) instead
	# of the ISO (c99) variant, as we want the __USE_XOPEN2K macro
	# to be defined.
	append-cflags -std=gnu99

	emake \
		CC="$(tc-getCC)" \
		USELIBPCRE=$(usev pcre) \
		USELIBCAP=$(usev caps) \
		USELIBWRAP=$(usev tcpd) \
		USESYSTEMD=$(usev systemd)
}

src_install() {
	dosbin sslh-{fork,select}
	dosym sslh-fork /usr/sbin/sslh

	doman ${PN}.8

	dodoc ChangeLog README.md

	newinitd "${FILESDIR}"/sslh.init.d-3 sslh
	newconfd "${FILESDIR}"/sslh.conf.d-2 sslh

	if use systemd; then
		# Gentoo puts the binaries in /usr/sbin, but upstream puts them in /usr/bin
		sed -i -e 's~/usr/bin/~/usr/sbin/~g' scripts/systemd.sslh.service || die
		systemd_newunit scripts/systemd.sslh.service sslh.service
		exeinto /usr/lib/systemd/system-generators/
		doexe systemd-sslh-generator
	fi
}
