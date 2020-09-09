# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GENTOO_DEPEND_ON_PERL="no"
ESVN_PROJECT=${PN}/trunk
ESVN_REPO_URI="https://svn.code.sf.net/p/${PN}/code/trunk/${PN}-wip"

inherit autotools flag-o-matic linux-info perl-module subversion systemd toolchain-funcs udev

DESCRIPTION="Takes control of the G15 keyboard, through the linux kernel uinput device driver"
HOMEPAGE="https://sourceforge.net/projects/g15daemon/"
[[ ${PV} = *9999* ]] || SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="perl static-libs"

DEPEND="virtual/libusb:0
	>=dev-libs/libg15-9999
	>=dev-libs/libg15render-9999
	perl? (
		dev-lang/perl
		dev-perl/GDGraph
		>=dev-perl/Inline-0.4
	)"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.9.5.3-g510-keys.patch"
	"${FILESDIR}/${PN}-1.9.5.3-docdir.patch"
	"${FILESDIR}/${PN}-1.9.5.3-avoid_bashisms.patch"
)

uinput_check() {
	ebegin "Checking for uinput support"
	local rc=1
	linux_config_exists && linux_chkconfig_present INPUT_UINPUT
	rc=$?

	if [[ ${rc} -ne 0 ]] ; then
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
	export CC="$(tc-getCC)" #729294

	linux-info_pkg_setup
	uinput_check
}

src_unpack() {
	if [[ ${PV} = *9999* ]] ; then
		subversion_src_unpack
	else
		unpack ${A}
	fi
	if use perl ; then
		unpack "./${P}/lang-bindings/perl-G15Daemon-0.2.tar.gz"
	fi
}

src_prepare() {
	if [[ ${PV} = *9999* ]] ; then
		subversion_wc_info
	fi
	if use perl ; then
		perl-module_src_prepare
		sed -i \
			-e '1i#!/usr/bin/perl' \
			"${S}"/contrib/testbindings.pl || die
	else
		# perl-module_src_prepare always calls base_src_prepare
		default
	fi
	if [[ ${PV} = *9999* ]] ; then
		mv configure.{in,ac} || die
		eautoreconf
	fi
}

src_configure() {
	append-cflags -fcommon #706712

	econf $(use_enable static-libs static)

	if use perl ; then
		cd "${WORKDIR}/G15Daemon-0.2" || die
		perl-module_src_configure
	fi
}

src_compile() {
	default

	if use perl ; then
		cd "${WORKDIR}/G15Daemon-0.2" || die
		perl-module_src_compile
	fi
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die

	# remove odd docs installed my make
	rm "${ED}"/usr/share/doc/${PF}/README.usage || die

	insinto /usr/share/${PN}/contrib
	doins contrib/xmodmaprc
	doins contrib/xmodmap.sh
	if use perl ; then
		doins contrib/testbindings.pl
	fi

	newconfd "${FILESDIR}/${PN}-1.2.7.confd" ${PN}
	newinitd "${FILESDIR}/${PN}-1.9.5.3.initd" ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"
	dobin "${FILESDIR}/g15daemon-hotplug"
	udev_dorules "${FILESDIR}/99-g15daemon.rules"

	insinto /etc
	doins "${FILESDIR}"/g15daemon.conf

	# Gentoo bug #301340, debian bug #611649
	exeinto /usr/lib/pm-utils/sleep.d
	doexe "${FILESDIR}"/20g15daemon

	if use perl ; then
		ebegin "Installing Perl Bindings (G15Daemon.pm)"
		cd "${WORKDIR}/G15Daemon-0.2" || die
		docinto perl
		perl-module_src_install
	fi
}

pkg_postinst() {
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
