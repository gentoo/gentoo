# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{6,7,8} )
SCONS_MIN_VERSION="2.3.0"

inherit eutils udev multilib distutils-r1 scons-utils toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://gitlab.com/gpsd/gpsd.git"
	inherit git-r3
else
	SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"
	#KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
fi

DESCRIPTION="GPS daemon and library for USB/serial GPS devices and GPS/mapping clients"
HOMEPAGE="https://gpsd.gitlab.io/gpsd/"

LICENSE="BSD"
SLOT="0/25"

GPSD_PROTOCOLS=(
	aivdm ashtech earthmate evermore fury fv18 garmin garmintxt geostar
	gpsclock greis isync itrax mtk3301 navcom nmea0183 nmea2000 ntrip
	oceanserver oncore passthrough rtcm104v2 rtcm104v3 sirf skytraq
	superstar2 tnt tripmate tsip ublox
)
IUSE_GPSD_PROTOCOLS=${GPSD_PROTOCOLS[@]/#/+gpsd_protocols_}
IUSE="${IUSE_GPSD_PROTOCOLS} bluetooth +cxx dbus debug ipv6 latency-timing ncurses ntp python qt5 +shm +sockets static test udev usb X"
REQUIRED_USE="X? ( python )
	gpsd_protocols_nmea2000? ( gpsd_protocols_aivdm )
	gpsd_protocols_isync? ( gpsd_protocols_ublox )
	gpsd_protocols_ublox? ( python )
	gpsd_protocols_greis? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	qt5? ( cxx )"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-user/gpsd
	>=net-misc/pps-tools-0.0.20120407
	bluetooth? ( net-wireless/bluez )
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
	gpsd_protocols_ublox? ( dev-python/pyserial )
	gpsd_protocols_greis? ( dev-python/pyserial )
	usb? ( virtual/libusb:1 )
	X? ( dev-python/pygobject:3[cairo,${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( sys-devel/bc )"

# xml packages are for man page generation
if [[ ${PV} == *9999* ]] ; then
	DEPEND+="
		app-text/xmlto
		=app-text/docbook-xml-dtd-4.1*"
fi

src_prepare() {
	# Make sure our list matches the source.
	local src_protocols=$(echo $(
		sed -n '/# GPS protocols/,/# Time service/{s:#.*::;s:[(",]::g;p}' "${S}"/SConstruct | awk '{print $1}' | LC_ALL=C sort
	) )
	if [[ ${src_protocols} != ${GPSD_PROTOCOLS[*]} ]] ; then
		eerror "Detected protocols: ${src_protocols}"
		eerror "Ebuild protocols:   ${GPSD_PROTOCOLS[*]}"
		die "please sync ebuild & source"
	fi

	# Avoid useless -L paths to the install dir
	sed -i \
		-e 's:\<STAGING_PREFIX\>:SYSROOT:g' \
		SConstruct || die

	#Fix systemd binary paths
	sed -i -e 's/local\///' 'systemd/gpsd.service'
	sed -i -e 's/local\///' 'systemd/gpsdctl@.service.in'

	default

	use python && distutils-r1_src_prepare
}

python_prepare_all() {
	python_setup

	# Extract python info out of SConstruct so we can use saner distribute
	pyvar() { sed -n "/^ *$1 *=/s:.*= *::p" SConstruct ; }
	local pybins=$(pyvar python_progs | tail -1)
	# Handle conditional tools manually. #666734
	use X && pybins+="+ ['xgps', 'xgpsspeed']"
	use gpsd_protocols_ublox && pybins+="+ ['ubxtool']"
	use gpsd_protocols_greis && pybins+="+ ['zerk']"
	local pysrcs=$(sed -n '/^ *python_extensions = {/,/}/{s:^ *::;s:os[.]sep:"/":g;p}' SConstruct)
	local packet=$("${PYTHON}" -c "${pysrcs}; print(python_extensions['gps/packet'])" || die "Unable to extract packet types")
	# Post 3.19 the clienthelpers were merged into gps.packet
	sed \
		-e "s|@VERSION@|$(pyvar gpsd_version)|" \
		-e "s|@URL@|$(pyvar website)|" \
		-e "s|@EMAIL@|$(pyvar devmail)|" \
		-e "s|@SCRIPTS@|${pybins}|" \
		-e "s|@GPS_PACKET_SOURCES@|${packet}|" \
		-e "/@GPS_CLIENT_SOURCES@/d" \
		-e "s|@SCRIPTS@|${pybins}|" \
		"${FILESDIR}"/${PN}-3.3-setup.py > setup.py || die
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
		manbuild=False
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
		socket_export=$(usex sockets)
		usb=$(usex usb)
	)

	use X && scons_opts+=( xgps=1 xgpsspeed=1 )
	use qt5 && scons_opts+=( qt_versioned=5 )

	# enable specified protocols
	local protocol
	for protocol in ${GPSD_PROTOCOLS[@]} ; do
		scons_opts+=( ${protocol}=$(usex gpsd_protocols_${protocol}) )
	done
}

src_compile() {
	export CHRPATH=
	tc-export CC CXX PKG_CONFIG
	export SHLINKFLAGS=${LDFLAGS} LINKFLAGS=${LDFLAGS}
	escons "${scons_opts[@]}"

	use python && distutils-r1_src_compile
}

src_install() {
	DESTDIR="${D}" escons install "${scons_opts[@]}" $(usex udev udev-install "")

	newconfd "${FILESDIR}"/gpsd.conf-2 gpsd
	newinitd "${FILESDIR}"/gpsd.init-2 gpsd

	# Cleanup bad alt copy due to Scons
	rm -rf  "${D}"/python-discard/gps*
	find "${D}"/python-discard/ -type d -delete
	# Install correct multi-python copy
	use python && distutils-r1_src_install

}
