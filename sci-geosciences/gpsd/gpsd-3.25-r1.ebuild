# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
SCONS_MIN_VERSION="2.3.0"

inherit distutils-r1 scons-utils systemd toolchain-funcs udev

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://gitlab.com/gpsd/gpsd.git"
	inherit git-r3
else
	SRC_URI="mirror://nongnu/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 arm ~arm64 ~loong ~ppc ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="GPS daemon and library for USB/serial GPS devices and GPS/mapping clients"
HOMEPAGE="https://gpsd.gitlab.io/gpsd/"

LICENSE="BSD-2"
SLOT="0/30"

GPSD_PROTOCOLS=(
	aivdm ashtech earthmate evermore fury fv18 garmin garmintxt geostar
	gpsclock greis isync itrax navcom nmea2000 oceanserver oncore
	rtcm104v2 rtcm104v3 sirf skytraq superstar2 tnt tripmate tsip ublox
)
IUSE_GPSD_PROTOCOLS=${GPSD_PROTOCOLS[@]/#/+gpsd_protocols_}
IUSE="${IUSE_GPSD_PROTOCOLS} bluetooth +cxx dbus debug ipv6 latency-timing ncurses ntp +python qt5 selinux +shm static systemd test udev usb X"
REQUIRED_USE="
	X? ( python )
	gpsd_protocols_nmea2000? ( gpsd_protocols_aivdm )
	gpsd_protocols_isync? ( gpsd_protocols_ublox )
	gpsd_protocols_ublox? ( python )
	gpsd_protocols_greis? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	qt5? ( cxx )
"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-user/gpsd
	acct-group/dialout
	>=net-misc/pps-tools-0.0.20120407
	bluetooth? ( net-wireless/bluez:= )
	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib
	)
	ncurses? ( sys-libs/ncurses:= )
	ntp? ( || (
		net-misc/ntp
		net-misc/ntpsec
		net-misc/chrony
	) )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
	)
	python? ( ${PYTHON_DEPS} )
	gpsd_protocols_ublox? ( dev-python/pyserial[${PYTHON_USEDEP}] )
	gpsd_protocols_greis? ( dev-python/pyserial[${PYTHON_USEDEP}] )
	usb? ( virtual/libusb:1 )
	X? ( dev-python/pygobject:3[cairo,${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	$(python_gen_any_dep 'dev-build/scons[${PYTHON_USEDEP}]')
	python? ( ${DISTUTILS_DEPS} )
	test? ( app-alternatives/bc )"
RDEPEND+=" selinux? ( sec-policy/selinux-gpsd )"

# asciidoctor package is for man page generation
if [[ ${PV} == *9999* ]] ; then
	BDEPEND+=" dev-ruby/asciidoctor"
fi

python_check_deps() {
	python_has_version -b "dev-build/scons[${PYTHON_USEDEP}]" || return 1
}

src_prepare() {
	# Make sure our list matches the source.
	local src_protocols=$(echo $(
		sed -n '/# GPS protocols/,/# Time service/{s:#.*::;s:[(",]::g;p}' \
		 "${S}"/SConscript | awk '{print $1}' | LC_ALL=C sort
	) )

	if [[ ${src_protocols} != ${GPSD_PROTOCOLS[*]} ]] ; then
		eerror "Detected protocols: ${src_protocols}"
		eerror "Ebuild protocols:   ${GPSD_PROTOCOLS[*]}"
		die "please sync ebuild & source"
	fi

	# bug #807661
	sed -i -e 's:$SRCDIR/gpsd.hotplug:$SRCDIR/../gpsd.hotplug:' SConscript || die

	default

	use python && distutils-r1_src_prepare
}

python_prepare_all() {
	python_setup

	# bug #796476
	python_export_utf8_locale

	# Extract python info out of SConscript so we can use saner distribute
	pyarray() { sed -n "/^ *$1 *= *\\[/,/\\]/p" SConscript ; }
	local pyprogs=$(pyarray python_progs)
	local pybins=$("${PYTHON}" -c "${pyprogs}; \
		print(list(set(python_progs) - {'xgps', 'xgpsspeed', 'ubxtool', 'zerk'}))" || die "Unable to list pybins")
	# Handle conditional tools manually. #666734
	use X && pybins+="+ ['xgps', 'xgpsspeed']"
	use gpsd_protocols_ublox && pybins+="+ ['ubxtool']"
	use gpsd_protocols_greis && pybins+="+ ['zerk']"
	local pysrcs=$(pyarray packet_ffi_extension)
	local packet=$("${PYTHON}" -c "${pysrcs}; print(packet_ffi_extension)" || die "Unable to extract packet types")

	pyvar() { sed -n "/^ *$1 *=/s:.*= *::p" SConscript ; }
	pyvar2() { sed -n "/^ *$1 *=/s:.*= *::p" SConstruct ; }

	# Post 3.19 the clienthelpers were merged into gps.packet

	# TODO: Fix hardcoding https://gpsd.io/ for now for @URL@
	sed \
		-e "s|@VERSION@|$(pyvar2 gpsd_version | sed -e 's:\"::g')|" \
		-e "s|@URL@|https://gpsd.io/|" \
		-e "s|@DEVMAIL@|$(pyvar devmail)|" \
		-e "s|@SCRIPTS@|${pybins}|" \
		-e "s|@DOWNLOAD@|$(pyvar download)|" \
		-e "s|@IRCCHAN@|$(pyvar ircchan)|" \
		-e "s|@ISSUES@|$(pyvar bugtracker)|" \
		-e "s|@MAILMAN@|$(pyvar mailman)|" \
		-e "s|@PROJECTPAGE@|$(pyvar projectpage)|" \
		-e "s|@SUPPORT@|https://gpsd.io/SUPPORT.html|" \
		-e "s|@WEBSITE@|https://gpsd.io/|" \
		"${S}"/packaging/gpsd-setup.py.in > setup.py || die
	distutils-r1_python_prepare_all
}

src_configure() {
	scons_opts=(
		prefix="${EPREFIX}/usr"
		libdir="\$prefix/$(get_libdir)"
		udevdir="$(get_udevdir)"
		rundir="/run"
		chrpath=False
		gpsd_user=gpsd
		gpsd_group=dialout
		nostrip=True
		systemd=$(usex systemd)
		unitdir="$(systemd_get_systemunitdir)"
		shared=$(usex !static True False)
		bluez=$(usex bluetooth)
		libgpsmm=$(usex cxx)
		clientdebug=$(usex debug)
		dbus_export=$(usex dbus)
		ipv6=$(usex ipv6)
		timing=$(usex latency-timing)
		ncurses=$(usex ncurses)
		ntpshm=$(usex ntp)
		pps=$(usex ntp)
		python=$(usex python)
		# force a predictable python libdir because lib vs. lib64 usage differs
		# from 3.5 to 3.6+
		$(usex python python_libdir="${EPREFIX}"/python-discard "")
		qt=$(usex qt5)
		shm_export=$(usex shm)
		socket_export=True # Required, see bug #900891
		usb=$(usex usb)
	)

	if [[ ${PV} != *9999* ]] ; then
		scons_opts+=( manbuild=False )
	fi

	use X && scons_opts+=( xgps=1 xgpsspeed=1 )
	use qt5 && scons_opts+=( qt_versioned=5 )

	# enable specified protocols
	local protocol
	for protocol in ${GPSD_PROTOCOLS[@]} ; do
		scons_opts+=( ${protocol}=$(usex gpsd_protocols_${protocol}) )
	done

	# bug #809260
	python_setup
}

src_compile() {
	export CHRPATH=
	tc-export CC CXX PKG_CONFIG
	export SHLINKFLAGS=${LDFLAGS} LINKFLAGS=${LDFLAGS}
	escons "${scons_opts[@]}"

	pushd "${P}" || die
	ln -sf ../setup.py . || die
	use python && distutils-r1_src_compile
	popd || die
}

src_test() {
	escons "${scons_opts[@]}" check
}

python_test() {
	# Silence QA check which gets confused by layout(?). We do run the tests.
	:;
}

python_install(){
	mkdir -p "${T}/scripts" || die
	grep -Rl "${D}/usr/bin" -e "/usr/bin/env python" | xargs mv -t "${T}/scripts"
	python_doscript "${T}"/scripts/*
	distutils-r1_python_install
}

src_install() {
	DESTDIR="${D}" escons install "${scons_opts[@]}" $(usev udev udev-install)

	newconfd "${FILESDIR}"/gpsd.conf-2 gpsd
	newinitd "${FILESDIR}"/gpsd.init-2 gpsd

	# Cleanup bad alt copy due to Scons
	rm -rf "${D}"/python-discard/gps*
	find "${D}"/python-discard/ -type d -delete
	# Install correct multi-python copy
	pushd "${P}" || die
	use python && distutils-r1_src_install
	popd || die
}

pkg_postinst() {
	use udev && udev_reload
}
