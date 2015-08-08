# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic readme.gentoo systemd toolchain-funcs versionator user

MY_PV="$(replace_version_separator 4 -)"
MY_PF="${PN}-${MY_PV}"
DESCRIPTION="Anonymizing overlay network for TCP"
HOMEPAGE="http://www.torproject.org/"
SRC_URI="https://www.torproject.org/dist/${MY_PF}.tar.gz
	https://archive.torproject.org/tor-package-archive/${MY_PF}.tar.gz"
S="${WORKDIR}/${MY_PF}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="-bufferevents nat-pmp scrypt seccomp selinux stats systemd tor-hardening transparent-proxy test upnp web"

DEPEND="dev-libs/openssl:=
	sys-libs/zlib
	dev-libs/libevent
	bufferevents? ( dev-libs/libevent[ssl] )
	nat-pmp? ( net-libs/libnatpmp )
	scrypt? ( app-crypt/libscrypt )
	seccomp? ( sys-libs/libseccomp )
	systemd? ( sys-apps/systemd )
	upnp? ( net-libs/miniupnpc )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-tor )"

pkg_setup() {
	enewgroup tor
	enewuser tor -1 -1 /var/lib/tor tor
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.2.3.14_alpha-torrc.sample.patch
	epatch_user
}

src_configure() {
	# Upstream isn't sure of all the user provided CFLAGS that
	# will break tor, but does recommend against -fstrict-aliasing.
	# We'll filter-flags them here as we encounter them.
	filter-flags -fstrict-aliasing

	econf \
		--enable-system-torrc \
		--enable-asciidoc \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable stats instrument-downloads) \
		$(use_enable bufferevents) \
		$(use_enable nat-pmp) \
		$(use_enable scrypt libscrypt) \
		$(use_enable seccomp) \
		$(use_enable systemd) \
		$(use_enable tor-hardening gcc-hardening) \
		$(use_enable tor-hardening linker-hardening) \
		$(use_enable transparent-proxy transparent) \
		$(use_enable upnp) \
		$(use_enable web tor2web-mode) \
		$(use_enable test unittests) \
		$(use_enable test coverage)
}

src_install() {
	readme.gentoo_create_doc

	newconfd "${FILESDIR}"/tor.confd tor
	newinitd "${FILESDIR}"/tor.initd-r7 tor
	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_dotmpfilesd "${FILESDIR}/${PN}.conf"

	emake DESTDIR="${D}" install

	keepdir /var/lib/tor

	dodoc README ChangeLog ReleaseNotes doc/HACKING

	fperms 750 /var/lib/tor
	fowners tor:tor /var/lib/tor

	insinto /etc/tor/
	newins "${FILESDIR}"/torrc-r1 torrc
}

pkg_postinst() {
	readme.gentoo_pkg_postinst

	if [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -eq 8 && $(gcc-micro-version) -ge 1 ]] ; then
		ewarn "Due to a bug in  >=gcc-4.8.1, compiling ${P} with -Os leads to an infinite"
		ewarn "loop.  See:"
		ewarn
		ewarn "    https://trac.torproject.org/projects/tor/ticket/10259"
		ewarn "    http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59358"
		ewarn
	fi
}
