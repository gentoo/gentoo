# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic ltprune multilib-minimal systemd toolchain-funcs udev user

# gphoto and v4l are handled by their usual USE flags.
# The pint backend was disabled because I could not get it to compile.
IUSE_SANE_BACKENDS="
	abaton
	agfafocus
	apple
	artec
	artec_eplus48u
	as6e
	avision
	bh
	canon
	canon630u
	canon_dr
	canon_pp
	cardscan
	coolscan
	coolscan2
	coolscan3
	dc210
	dc240
	dc25
	dell1600n_net
	dmc
	epjitsu
	epson
	epson2
	fujitsu
	genesys
	gt68xx
	hp
	hp3500
	hp3900
	hp4200
	hp5400
	hp5590
	hpljm1005
	hpsj5s
	hs2p
	ibm
	kodak
	kodakaio
	kvs1025
	kvs20xx
	kvs40xx
	leo
	lexmark
	ma1509
	magicolor
	matsushita
	microtek
	microtek2
	mustek
	mustek_pp
	mustek_usb
	mustek_usb2
	nec
	net
	niash
	p5
	pie
	pixma
	plustek
	plustek_pp
	pnm
	qcam
	ricoh
	rts8891
	s9036
	sceptre
	sharp
	sm3600
	sm3840
	snapscan
	sp15c
	st400
	stv680
	tamarack
	teco1
	teco2
	teco3
	test
	u12
	umax
	umax1220u
	umax_pp
	xerox_mfp"

IUSE="gphoto2 ipv6 snmp systemd threads usb v4l xinetd zeroconf"

for backend in ${IUSE_SANE_BACKENDS}; do
	case ${backend} in
	# Disable backends that require parallel ports as no one has those anymore.
	canon_pp|hpsj5s|mustek_pp|\
	pnm)
		IUSE+=" -sane_backends_${backend}"
		;;
	mustek_usb2|kvs40xx)
		IUSE+=" sane_backends_${backend}"
		;;
	*)
		IUSE+=" +sane_backends_${backend}"
	esac
done

REQUIRED_USE="
	sane_backends_mustek_usb2? ( threads )
	sane_backends_kvs40xx? ( threads )
"

DESCRIPTION="Scanner Access Now Easy - Backends"
HOMEPAGE="http://www.sane-project.org/"
case ${PV} in
9999)
	EGIT_REPO_URI="git://anonscm.debian.org/sane/sane-backends.git"
	inherit git-r3 autotools
	;;
*_pre*)
	MY_P="${PN}-git${PV#*_pre}"
	SRC_URI="http://www.sane-project.org/snapshots/${MY_P}.tar.gz
		mirror://gentoo/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
	;;
*)
	MY_P=${P}
	FRS_ID="4224"
	SRC_URI="https://alioth.debian.org/frs/download.php/file/${FRS_ID}/${P}.tar.gz"
	;;
esac

LICENSE="GPL-2 public-domain"
SLOT="0"
if [[ ${PV} != "9999" ]] ; then
	KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
fi

RDEPEND="
	sane_backends_dc210? ( >=virtual/jpeg-0-r2:0=[${MULTILIB_USEDEP}] )
	sane_backends_dc240? ( >=virtual/jpeg-0-r2:0=[${MULTILIB_USEDEP}] )
	sane_backends_dell1600n_net? (
		>=virtual/jpeg-0-r2:0=[${MULTILIB_USEDEP}]
		>=media-libs/tiff-3.9.7-r1:0=[${MULTILIB_USEDEP}]
	)
	sane_backends_canon_pp? ( >=sys-libs/libieee1284-0.2.11-r3[${MULTILIB_USEDEP}] )
	sane_backends_hpsj5s? ( >=sys-libs/libieee1284-0.2.11-r3[${MULTILIB_USEDEP}] )
	sane_backends_mustek_pp? ( >=sys-libs/libieee1284-0.2.11-r3[${MULTILIB_USEDEP}] )
	usb? ( >=virtual/libusb-1-r1:1=[${MULTILIB_USEDEP}] )
	gphoto2? (
		>=media-libs/libgphoto2-2.5.3.1:=[${MULTILIB_USEDEP}]
		>=virtual/jpeg-0-r2:0=[${MULTILIB_USEDEP}]
	)
	v4l? ( >=media-libs/libv4l-0.9.5[${MULTILIB_USEDEP}] )
	xinetd? ( sys-apps/xinetd )
	snmp? ( net-analyzer/net-snmp )
	systemd? ( sys-apps/systemd:0= )
	zeroconf? ( >=net-dns/avahi-0.6.31-r2[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}
	v4l? ( sys-kernel/linux-headers )
	>=sys-devel/gettext-0.18.1
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

# We now use new syntax construct (SUBSYSTEMS!="usb|usb_device)
RDEPEND="${RDEPEND}
	!<sys-fs/udev-114
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/sane-config
)

pkg_setup() {
	enewgroup scanner
	enewuser saned -1 -1 -1 scanner
}

src_prepare() {
	default

	cat >> backend/dll.conf.in <<-EOF
	# Add support for the HP-specific backend.  Needs net-print/hplip installed.
	hpaio
	# Add support for the Epson-specific backend.  Needs media-gfx/iscan installed.
	epkowa
	EOF

	eapply "${FILESDIR}"/${PN}-1.0.24-saned_pidfile_location.patch
	eapply "${FILESDIR}"/${PN}-1.0.27-disable-usb-tests.patch

	if [[ ${PV} == "9999" ]] ; then
		mv configure.{in,ac} || die
		AT_NOELIBTOOLIZE=yes eautoreconf
	fi

	# Fix for "make check".  Upstream sometimes forgets to update this.
	local ver=$(./configure --version | awk '{print $NF; exit 0}')
	sed -i \
		-e "/by sane-desc 3.5 from sane-backends/s:sane-backends .*:sane-backends ${ver}:" \
		testsuite/tools/data/html* || die
}

src_configure() {
	append-flags -fno-strict-aliasing # bug?????

	# if LINGUAS is set, just use the listed and supported localizations.
	if [[ ${LINGUAS+set} == "set" ]]; then
		mkdir -p po || die
		strip-linguas -u po
		printf '%s\n' ${LINGUAS} > po/LINGUAS
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# the blank is intended - an empty string would result in building ALL backends.
	local BACKENDS=" "

	use gphoto2 && BACKENDS="gphoto2"
	use v4l && BACKENDS="${BACKENDS} v4l"
	for backend in ${IUSE_SANE_BACKENDS}; do
		if use "sane_backends_${backend}" && [ ${backend} != pnm ]; then
			BACKENDS="${BACKENDS} ${backend}"
		fi
	done

	local myconf=(
		$(use_with usb)
		$(multilib_native_use_with snmp)
	)

	# you can only enable this backend, not disable it...
	if use sane_backends_pnm; then
		myconf+=( --enable-pnm-backend )
	fi
	if use sane_backends_mustek_pp; then
		myconf+=( --enable-parport-directio )
	fi
	if ! { use sane_backends_canon_pp || use sane_backends_hpsj5s || use sane_backends_mustek_pp; }; then
		myconf+=( sane_cv_use_libieee1284=no )
	fi

	# relative path must be used for tests to work properly
	ECONF_SOURCE=${S} \
	SANEI_JPEG="sanei_jpeg.o" SANEI_JPEG_LO="sanei_jpeg.lo" \
	BACKENDS="${BACKENDS}" \
	econf \
		$(use_with gphoto2) \
		$(multilib_native_use_with systemd) \
		$(use_with v4l) \
		$(use_enable ipv6) \
		$(use_enable threads pthread) \
		$(use_enable zeroconf avahi) \
		"${myconf[@]}"
}

multilib_src_compile() {
	emake VARTEXFONTS="${T}/fonts"

	if tc-is-cross-compiler; then
		pushd "${BUILD_DIR}"/tools >/dev/null || die

		# The build system sucks and doesn't handle this properly.
		# https://alioth.debian.org/tracker/index.php?func=detail&aid=314236&group_id=30186&atid=410366
		tc-export_build_env BUILD_CC
		${BUILD_CC} ${BUILD_CPPFLAGS} ${BUILD_CFLAGS} ${BUILD_LDFLAGS} \
			-I. -I../include -I"${S}"/include \
			"${S}"/sanei/sanei_config.c "${S}"/sanei/sanei_constrain_value.c \
			"${S}"/sanei/sanei_init_debug.c "${S}"/tools/sane-desc.c -o sane-desc || die
		local dirs=( hal hotplug hotplug-ng udev )
		local targets=(
			hal/libsane.fdi
			hotplug/libsane.usermap
			hotplug-ng/libsane.db
			udev/libsane.rules
		)
		mkdir -p "${dirs[@]}" || die
		emake "${targets[@]}"

		popd >/dev/null
	fi

	if use usb; then
		sed -i -e '/^$/d' \
			tools/hotplug/libsane.usermap || die
	fi
}

multilib_src_install() {
	emake INSTALL_LOCKPATH="" DESTDIR="${D}" install \
		docdir="${EPREFIX}"/usr/share/doc/${PF}

	if multilib_is_native_abi; then
		if use usb; then
			insinto /etc/hotplug/usb
			doins tools/hotplug/libsane.usermap
		fi

		udev_newrules tools/udev/libsane.rules 41-libsane.rules
		insinto "/usr/share/pkgconfig"
		doins tools/sane-backends.pc
	fi
}

multilib_src_install_all() {
	keepdir /var/lib/lock/sane
	fowners root:scanner /var/lib/lock/sane
	fperms g+w /var/lib/lock/sane
	dodir /etc/env.d

	if use systemd; then
		systemd_newunit "${FILESDIR}"/saned_at.service "saned@.service"
		systemd_newunit "${FILESDIR}"/saned.socket saned.socket
	fi

	if use usb; then
		exeinto /etc/hotplug/usb
		doexe tools/hotplug/libusbscanner
		newdoc tools/hotplug/README README.hotplug
	fi

	dodoc NEWS AUTHORS ChangeLog* PROBLEMS README README.linux
	prune_libtool_files --modules
	if use xinetd; then
		insinto /etc/xinetd.d
		doins "${FILESDIR}"/saned
	fi

	newinitd "${FILESDIR}"/saned.initd saned
	newconfd "${FILESDIR}"/saned.confd saned
}

pkg_postinst() {
	if use xinetd; then
		elog "If you want remote clients to connect, edit"
		elog "/etc/sane.d/saned.conf and /etc/hosts.allow"
	fi

	elog "If you are using a USB scanner, add all users who want"
	elog "to access your scanner to the \"scanner\" group."
}
