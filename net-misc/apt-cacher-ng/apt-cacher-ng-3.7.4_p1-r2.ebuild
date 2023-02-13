# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake tmpfiles

MY_PV="${PV/_p/-}"
MY_P="${PN}-debian-${MY_PV}"

DESCRIPTION="Yet another caching HTTP proxy for Debian/Ubuntu software packages"
HOMEPAGE="https://www.unix-ag.uni-kl.de/~bloch/acng/
	https://packages.qa.debian.org/a/apt-cacher-ng.html"
SRC_URI="https://salsa.debian.org/blade/${PN}/-/archive/debian/${MY_PV}/${MY_P}.tar.gz"

LICENSE="BSD-4 ZLIB public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fuse systemd tcpd"

DEPEND="acct-user/apt-cacher-ng
	acct-group/apt-cacher-ng
	app-arch/bzip2
	dev-libs/libevent:=[threads(+)]
	dev-libs/openssl:0=
	net-dns/c-ares:=
	sys-libs/zlib
	fuse? ( sys-fs/fuse:0 )
	systemd? ( sys-apps/systemd )
	tcpd? ( sys-apps/tcp-wrappers )"
BDEPEND="virtual/pkgconfig"
RDEPEND="${DEPEND}
	dev-lang/perl"

PATCHES=(
	"${FILESDIR}/${PN}-3.3.1-flags.patch"
	"${FILESDIR}/${PN}-3.5-perl-syntax.patch"
	"${FILESDIR}/${PN}-3.6-optional-systemd.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Fixup systemd/CMakeLists.txt cmake version requirement
	sed -ie "s/2.6/3.1/" systemd/CMakeLists.txt || die

	# Make sure we install everything the same way it used to be after
	# switching from mostly custom src_install to relying on build system
	# installation
	sed -e "/install/s/LIBDIR/CFGDIR/" \
		-e "/install.*acng\.conf/s/)$/ RENAME ${PN}.conf)/" \
		-e "/file/s/)$/ \"*hooks\" \"backends_debian\")/" -i conf/CMakeLists.txt || die
	sed -ie "/INSTALL.*acngtool/s/LIBDIR/CMAKE_INSTALL_SBINDIR/" src/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DHAVE_FUSE_25=$(usex fuse)"
		"-DHAVE_LIBWRAP=$(usex tcpd)"
		"-DSDINSTALL=$(usex systemd)"
	)

	cmake_src_configure

	sed -ie '/LogDir/s|/var/tmp|/var/log/'"${PN}"'|g' "${BUILD_DIR}"/conf/acng.conf || die
}

src_install() {
	# README is a symlink to doc/README and README automatically gets
	# installed, leading to a broken symlink installed. Fix this by removing
	# the symlink then installing the actual README. https://bugs.gentoo.org/770046
	rm README || die
	dodoc doc/README

	newinitd "${FILESDIR}/initd-r3" "${PN}"
	newconfd "${FILESDIR}/confd-r2" "${PN}"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate" "${PN}"

	insinto /etc/cron.daily
	newins "${FILESDIR}/cron.daily" "${PN}"

	# USE=fuse installs acngfs, don't install manpage without the bin
	if use !fuse; then
		rm doc/man/acngfs.8 || die
	fi

	if use !doc; then
		rm -r doc/html || die
	fi

	dosbin scripts/expire-caller.pl

	keepdir "/var/log/${PN}"
	fowners -R ${PN}:${PN} "/var/log/${PN}"

	cmake_src_install
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"
}
