# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/g15daemon/g15daemon-1.9.5.3-r11.ebuild,v 1.1 2014/11/09 11:49:18 zlogene Exp $

EAPI=5
GENTOO_DEPEND_ON_PERL="no"
PYTHON_DEPEND="python? *"
SUPPORT_PYTHON_ABIS="1"

inherit eutils linux-info perl-module python base

DESCRIPTION="G15daemon takes control of the G15 keyboard, through the linux kernel uinput device driver"
HOMEPAGE="http://g15daemon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="perl python static-libs"

DEPEND="virtual/libusb:0
	>=dev-libs/libg15-1.2.4
	>=dev-libs/libg15render-1.2
	perl? (
		dev-lang/perl
		dev-perl/GDGraph
		>=dev-perl/Inline-0.4
	)"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-forgotten-open-mode.patch"
	"${FILESDIR}/${P}-overflow-fix.patch"
)
uinput_check() {
	ebegin "Checking for uinput support"
	local rc=1
	linux_config_exists && linux_chkconfig_present INPUT_UINPUT
	rc=$?

	if [[ $rc -ne 0 ]] ; then
		eerror "To use g15daemon, you need to compile your kernel with uinput support."
		eerror "Please enable uinput support in your kernel config, found at:"
		eerror
		eerror "Device Drivers -> Input Device ... -> Miscellaneous devices -> User level driver support."
		eerror
		eerror "Once enabled, you should have the /dev/input/uinput device."
		eerror "g15daemon will not work without the uinput device."
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	uinput_check
	if use python; then
		python_pkg_setup
	fi
}

src_unpack() {
	unpack ${A}
	if use perl; then
		unpack "./${P}/lang-bindings/perl-G15Daemon-0.2.tar.gz"
	fi
	if use python; then
		unpack "./${P}/lang-bindings/pyg15daemon-0.0.tar.bz2"
	fi
}

src_prepare() {
	if use perl; then
		perl-module_src_prepare
		sed -i \
			-e '1i#!/usr/bin/perl' \
			"${S}"/contrib/testbindings.pl
	else
		# perl-module_src_prepare always calls base_src_prepare
		base_src_prepare
	fi
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable static-libs static)

	if use perl; then
		cd "${WORKDIR}/G15Daemon-0.2"
		perl-module_src_configure
	fi
}

src_compile() {
	default

	if use perl; then
		cd "${WORKDIR}/G15Daemon-0.2"
		perl-module_src_compile
	fi
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +

	# remove odd docs installed my make
	rm "${ED}/usr/share/doc/${PF}/"{LICENSE,README.usage}

	insinto /usr/share/${PN}/contrib
	doins contrib/xmodmaprc
	doins contrib/xmodmap.sh
	if use perl; then
		doins contrib/testbindings.pl
	fi

	newconfd "${FILESDIR}/${PN}-1.2.7.confd" ${PN}
	newinitd "${FILESDIR}/${PN}-1.9.5.3.initd" ${PN}
	dobin "${FILESDIR}/g15daemon-hotplug"
	insinto /lib/udev/rules.d
	doins "${FILESDIR}/99-g15daemon.rules"

	insinto /etc
	doins "${FILESDIR}"/g15daemon.conf

	# Gentoo bug #301340, debian bug #611649
	exeinto /usr/lib/pm-utils/sleep.d
	doexe "${FILESDIR}"/20g15daemon

	if use perl; then
		ebegin "Installing Perl Bindings (G15Daemon.pm)"
		cd "${WORKDIR}/G15Daemon-0.2"
		docinto perl
		perl-module_src_install
	fi

	if use python; then
		ebegin "Installing Python Bindings (g15daemon.py)"
		cd "${WORKDIR}/pyg15daemon"

		installation() {
			insinto $(python_get_sitedir)
			doins g15daemon.py
		}
		python_execute_function installation

		docinto python
		dodoc AUTHORS
	fi
}

pkg_postinst() {
	if use python; then
		python_mod_optimize g15daemon.py
		echo ""
	fi

	elog "To use g15daemon, you need to add g15daemon to the default runlevel."
	elog "This can be done with:"
	elog "# /sbin/rc-update add g15daemon default"
	elog "You can edit some g15daemon options at /etc/conf.d/g15daemon"
	elog ""
	elog "To have all new keys working in X11, you'll need create a "
	elog "specific xmodmap in your home directory or edit the existent one."
	elog ""
	elog "Create the xmodmap:"
	elog "cp /usr/share/g15daemon/contrib/xmodmaprc ~/.Xmodmap"
	elog ""
	elog "Adding keycodes to an existing xmodmap:"
	elog "cat /usr/share/g15daemon/contrib/xmodmaprc >> ~/.Xmodmap"
}

pkg_postrm() {
	if use python; then
		python_mod_cleanup g15daemon.py
	fi
}
