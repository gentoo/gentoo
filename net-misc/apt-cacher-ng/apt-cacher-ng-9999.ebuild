# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Yet another caching HTTP proxy for Debian/Ubuntu software packages"
HOMEPAGE="https://www.unix-ag.uni-kl.de/~bloch/acng/
	https://packages.qa.debian.org/a/apt-cacher-ng.html"
EGIT_REPO_URI="https://salsa.debian.org/blade/apt-cacher-ng.git"
EGIT_BRANCH="upstream/sid"

LICENSE="BSD-4 ZLIB public-domain"
SLOT="0"
IUSE="doc fuse tcpd"

DEPEND="acct-user/apt-cacher-ng
	acct-group/apt-cacher-ng
	app-arch/bzip2
	dev-libs/libevent:=
	dev-libs/openssl:0=
	sys-libs/zlib
	fuse? ( sys-fs/fuse:0 )
	tcpd? ( sys-apps/tcp-wrappers )"
BDEPEND="virtual/pkgconfig"
RDEPEND="${DEPEND}
	dev-lang/perl"

PATCHES=(
	"${FILESDIR}/${PN}-3.3.1-flags.patch"
	"${FILESDIR}/${PN}-3.5-perl-syntax.patch"
)

S="${WORKDIR}/${P/_*}"

src_prepare() {
	# Fixup systemd/CMakeLists.txt cmake version requirement
	sed -ie "s/2.6/3.1/" systemd/CMakeLists.txt || die

	# Make sure we install everything the same way it used to be after
	# switching from mostly custom src_install to relying on build system
	# installation
	sed -ie "/install/s/LIBDIR/CFGDIR/" conf/CMakeLists.txt || die
	sed -ie '/install.*acng\.conf/s/)$/ RENAME '"${PN}"'.conf)/' conf/CMakeLists.txt || die
	sed -ie '/file/s/)$/ "*hooks" "backends_debian")/' conf/CMakeLists.txt || die
	sed -ie "/INSTALL.*acngtool/s/LIBDIR/CMAKE_INSTALL_SBINDIR/" source/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DHAVE_FUSE_25=$(usex fuse)"
		"-DHAVE_LIBWRAP=$(usex tcpd)"
		# Unconditionally install systemd service file
		"-DSDINSTALL=1"
	)

	if tc-ld-is-gold; then
		mycmakeargs+=( "-DUSE_GOLD=yes" )
	else
		mycmakeargs+=( "-DUSE_GOLD=no" )
	fi

	cmake_src_configure

	sed -ie '/LogDir/s|/var/tmp|/var/log/'"${PN}"'|g' "${BUILD_DIR}"/conf/acng.conf || die
}

src_install() {
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
