# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic pam systemd toolchain-funcs user

DESCRIPTION="Opensourced tools for VMware guests"
HOMEPAGE="https://github.com/vmware/open-vm-tools"
MY_P="${P}-3227872"
SRC_URI="https://github.com/vmware/open-vm-tools/files/133266/${MY_P}.tar.gz"

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
PATCHES=(
	"${FILESDIR}/9.10.0-vgauth.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# libsigc++-2.0 >= 2.5.1 requires C++11. Using -std=c++11
	# does not provide "linux" definition, we need gnu++11
	append-cxxflags -std=gnu++11

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
		$(use_with X gtk2)
		$(use_with X gtkmm)
		$(use_with X x)
	)

	econf "${myeconfargs[@]}"

	# Bugs 260878, 326761
	find . -name Makefile -exec sed -i -e 's/-Werror//g' '{}' +  || die "sed out Werror failed"
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

pkg_postinst() {
	enewgroup vmware
}
