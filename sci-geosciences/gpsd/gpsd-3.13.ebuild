# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python2_7 )
SCONS_MIN_VERSION="1.2.1"

inherit eutils udev user multilib distutils-r1 scons-utils toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.savannah.nongnu.org/gpsd.git"
	inherit git-2
else
	SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="GPS daemon and library to support USB/serial GPS devices and various GPS/mapping clients"
HOMEPAGE="http://catb.org/gpsd/"

LICENSE="BSD"
SLOT="0"

GPSD_PROTOCOLS=(
	aivdm ashtech earthmate evermore fury fv18 garmin garmintxt
	geostar gpsclock itrax mtk3301 navcom nmea0183 nmea2000 ntrip
	oceanserver oncore passthrough rtcm104v2 rtcm104v3 sirf superstar2
	tnt tripmate tsip ublox
)
IUSE_GPSD_PROTOCOLS=${GPSD_PROTOCOLS[@]/#/gpsd_protocols_}
IUSE="${IUSE_GPSD_PROTOCOLS} bluetooth cxx debug dbus ipv6 latency_timing ncurses ntp python qt4 +shm +sockets static test udev usb X"
REQUIRED_USE="X? ( python )
	gpsd_protocols_nmea2000? ( gpsd_protocols_aivdm )
	python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="X? ( dev-python/pygtk:2[${PYTHON_USEDEP}] )
	ncurses? ( sys-libs/ncurses )
	bluetooth? ( net-wireless/bluez )
	usb? ( virtual/libusb:1 )
	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib
	)
	ntp? ( || ( net-misc/ntp net-misc/chrony ) )
	qt4? ( dev-qt/qtgui:4 )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( sys-devel/bc )"

# xml packages are for man page generation
if [[ ${PV} == "9999" ]] ; then
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

	epatch "${FILESDIR}"/${PN}-3.8-ldflags.patch
	epatch "${FILESDIR}"/${PN}-3.11-rpath.patch
	epatch "${FILESDIR}"/${PN}-3.13-ntpshm.patch

	# Avoid useless -L paths to the install dir
	sed -i \
		-e 's:\<STAGING_PREFIX\>:SYSROOT:g' \
		SConstruct || die

	use python && distutils-r1_src_prepare
}

python_prepare_all() {
	python_export_best
	# Extract python info out of SConstruct so we can use saner distribute
	pyvar() { sed -n "/^ *$1 *=/s:.*= *::p" SConstruct ; }
	local pybins=$(pyvar python_progs | tail -1)
	local pysrcs=$(sed -n '/^ *python_extensions = {/,/}/{s:^ *::;s:os[.]sep:"/":g;p}' SConstruct)
	local packet=$("${PYTHON}" -c "${pysrcs}; print(python_extensions['gps/packet'])")
	local client=$("${PYTHON}" -c "${pysrcs}; print(python_extensions['gps/clienthelpers'])")
	sed \
		-e "s|@VERSION@|$(pyvar gpsd_version)|" \
		-e "s|@URL@|$(pyvar website)|" \
		-e "s|@EMAIL@|$(pyvar devmail)|" \
		-e "s|@SCRIPTS@|${pybins}|" \
		-e "s|@GPS_PACKET_SOURCES@|${packet}|" \
		-e "s|@GPS_CLIENT_SOURCES@|${client}|" \
		-e "s|@SCRIPTS@|${pybins}|" \
		"${FILESDIR}"/${PN}-3.3-setup.py > setup.py || die
	distutils-r1_python_prepare_all
}

src_configure() {
	myesconsargs=(
		prefix="${EPREFIX}/usr"
		libdir="\$prefix/$(get_libdir)"
		udevdir="$(get_udevdir)"
		chrpath=False
		gpsd_user=gpsd
		gpsd_group=uucp
		nostrip=True
		python=False
		manbuild=False
		shared=$(usex !static True False)
		$(use_scons bluetooth bluez)
		$(use_scons cxx libgpsmm)
		$(use_scons debug clientdebug)
		$(use_scons dbus dbus_export)
		$(use_scons ipv6)
		$(use_scons latency_timing timing)
		$(use_scons ncurses)
		$(use_scons ntp ntpshm)
		$(use_scons ntp pps)
		$(use_scons shm shm_export)
		$(use_scons sockets socket_export)
		$(use_scons qt4 libQgpsmm)
		$(use_scons usb)
	)

	# enable specified protocols
	local protocol
	for protocol in ${GPSD_PROTOCOLS[@]} ; do
		myesconsargs+=( $(use_scons gpsd_protocols_${protocol} ${protocol}) )
	done
}

src_compile() {
	export CHRPATH=
	tc-export CC CXX PKG_CONFIG
	export SHLINKFLAGS=${LDFLAGS} LINKFLAGS=${LDFLAGS}
	escons

	use python && distutils-r1_src_compile
}

src_install() {
	DESTDIR="${D}" escons install $(usex udev udev-install "")

	newconfd "${FILESDIR}"/gpsd.conf-2 gpsd
	newinitd "${FILESDIR}"/gpsd.init-2 gpsd

	if use python ; then
		distutils-r1_src_install
		# Delete all X related packages if user doesn't want them
		if ! use X ; then
			rm "${ED%/}"/usr/bin/xgps* || die
		fi
	fi
}

pkg_preinst() {
	# Run the gpsd daemon as gpsd and group uucp; create it here
	# as it doesn't seem to be needed during compile/install ...
	enewuser gpsd -1 -1 -1 "uucp"
}
