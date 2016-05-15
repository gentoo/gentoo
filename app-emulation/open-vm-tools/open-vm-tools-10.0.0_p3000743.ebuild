# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils flag-o-matic multilib pam systemd toolchain-funcs user versionator

MY_P="${PN}-${PV/_p/-}"

DESCRIPTION="Opensourced tools for VMware guests"
HOMEPAGE="https://github.com/vmware/open-vm-tools"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X doc grabbitmqproxy icu pam +pic vgauth xinerama"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libdnet
	sys-apps/ethtool
	sys-fs/fuse
	>=sys-process/procps-3.3.2
	grabbitmqproxy? ( dev-libs/openssl:0 )
	icu? ( dev-libs/icu:= )
	pam? ( virtual/pam )
	vgauth? (
		dev-libs/openssl:0
		dev-libs/xerces-c
		dev-libs/xml-security-c
	)
	X? (
		dev-cpp/gtkmm:2.4
		x11-base/xorg-server
		x11-drivers/xf86-input-vmmouse
		x11-drivers/xf86-video-vmware
		x11-libs/gtk+:2
		x11-libs/libnotify
		x11-libs/libX11
		x11-libs/libXtst
	)
	xinerama? ( x11-libs/libXinerama )
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	sys-apps/findutils
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup vmware
}

src_prepare() {
	epatch "${FILESDIR}/9.10.0-vgauth.patch"
	epatch_user
	eautoreconf
}

src_configure() {
	# libsigc++-2.0 >= 2.5.1 requires C++11. Using -std=c++11
	# does not provide "linux" definition, we need gnu++11
	append-cxxflags -std=gnu++11

	# https://bugs.gentoo.org/402279
	export CUSTOM_PROCPS_NAME=procps
	export CUSTOM_PROCPS_LIBS="$($(tc-getPKG_CONFIG) --libs libprocps)"

	local myeconfargs=(
		--disable-deploypkg
		--disable-tests
		# Broken build
		--docdir=/usr/share/doc/${PF}
		--with-procps
		--with-dnet
		--without-kernel-modules
		$(use_enable doc docs)
		$(use_enable grabbitmqproxy)
		$(use_enable vgauth)
		$(use_enable xinerama multimon)
		$(use_with icu)
		$(use_with pam)
		$(use_with pic)
		$(use_with X gtk2)
		$(use_with X gtkmm)
		$(use_with X x)
	)

	econf "${myeconfargs[@]}"

	# Bugs 260878, 326761
	find . -name Makefile | xargs sed -i -e 's/-Werror//g'  || die "sed out Werror failed"
}

src_install() {
	emake DESTDIR="${D%/}" install
	dodoc AUTHORS NEWS ChangeLog README
	prune_libtool_files --modules

	rm "${ED%/}"/etc/pam.d/vmtoolsd
	pamd_mimic_system vmtoolsd auth account

	newinitd "${FILESDIR}/open-vm-tools.initd" vmware-tools
	newconfd "${FILESDIR}/open-vm-tools.confd" vmware-tools
	systemd_dounit "${FILESDIR}"/vmtoolsd.service

	if use X; then
		fperms 4755 /usr/bin/vmware-user-suid-wrapper
		dobin scripts/common/vmware-xdg-detect-de

		insinto /etc/xdg/autostart
		doins "${FILESDIR}"/open-vm-tools.desktop

		elog "To be able to use the drag'n'drop feature of VMware for file"
		elog "exchange, please add the users to the 'vmware' group."
	fi
}
