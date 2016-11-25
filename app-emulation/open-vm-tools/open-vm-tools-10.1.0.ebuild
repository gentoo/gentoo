# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic pam systemd toolchain-funcs user

DESCRIPTION="Opensourced tools for VMware guests"
HOMEPAGE="https://github.com/vmware/open-vm-tools"
MY_P="${P}-4449150"
SRC_URI="https://github.com/vmware/open-vm-tools/files/590760/${MY_P}.tar.gz"

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
		dev-cpp/gtkmm:3.0
		x11-base/xorg-server
		x11-drivers/xf86-input-vmmouse
		x11-drivers/xf86-video-vmware
		x11-libs/gtk+:3
		x11-libs/libnotify
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXrandr
		x11-libs/libXtst
		xinerama? ( x11-libs/libXinerama )
	)
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	sys-apps/findutils
"

S="${WORKDIR}/${MY_P}/open-vm-tools"

src_prepare() {
	eapply -p2 "${FILESDIR}/10.1.0-vgauth.patch"
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-deploypkg
		--disable-static
		--disable-tests
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
		--without-gtk2
		--without-gtkmm
		$(use_with X gtk3)
		$(use_with X gtkmm3)
		$(use_with X x)
	)

	econf "${myeconfargs[@]}"

	# Bugs 260878, 326761
	find . -name Makefile -exec sed -i -e 's/-Werror//g' '{}' +  || die "sed out Werror failed"
}

src_install() {
	default
	prune_libtool_files --modules

	rm "${ED%/}"/etc/pam.d/vmtoolsd || die
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

pkg_postinst() {
	enewgroup vmware
}
