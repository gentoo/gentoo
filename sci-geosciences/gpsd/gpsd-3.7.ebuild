# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

PYTHON_DEPEND="python? 2:2.6"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"
SCONS_MIN_VERSION="1.2.1"

inherit eutils udev user multilib distutils scons-utils toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.savannah.nongnu.org/gpsd.git"
	inherit git-2
else
	SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 arm ppc ppc64 x86"
fi

DESCRIPTION="GPS daemon and library to support USB/serial GPS devices and various GPS/mapping clients"
HOMEPAGE="http://catb.org/gpsd/"

LICENSE="BSD"
SLOT="0"

GPSD_PROTOCOLS=(
	ashtech aivdm clientdebug earthmate evermore fv18 garmin
	garmintxt gpsclock itrax mtk3301 nmea ntrip navcom oceanserver
	oldstyle oncore rtcm104v2 rtcm104v3 sirf superstar2 timing tsip
	tripmate tnt ubx
)
IUSE_GPSD_PROTOCOLS=${GPSD_PROTOCOLS[@]/#/gpsd_protocols_}
IUSE="${IUSE_GPSD_PROTOCOLS} bluetooth cxx debug dbus ipv6 ncurses ntp python qt4 +shm +sockets test udev usb X"
REQUIRED_USE="X? ( python )"

RDEPEND="X? ( dev-python/pygtk:2 )
	ncurses? ( sys-libs/ncurses )
	bluetooth? ( net-wireless/bluez )
	usb? ( virtual/libusb:1 )
	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib
	)
	ntp? ( || ( net-misc/ntp net-misc/chrony ) )
	qt4? ( dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( sys-devel/bc )"

# xml packages are for man page generation
if [[ ${PV} == "9999" ]] ; then
	DEPEND+="
		app-text/xmlto
		=app-text/docbook-xml-dtd-4.1*"
fi

pkg_setup() {
	use python && python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.3-ldflags.patch
	epatch "${FILESDIR}"/${PN}-3.4-always-install-man-pages.patch
	epatch "${FILESDIR}"/${PN}-3.4-no-man-gen.patch
	epatch "${FILESDIR}"/${PN}-3.7-rpath.patch
	epatch "${FILESDIR}"/${PN}-3.7-gps_regress.patch #441760
	epatch "${FILESDIR}"/${PN}-3.7-no-export-t.patch #463850

	# Avoid useless -L paths to the install dir
	sed -i \
		-e '/^env.Prepend(LIBPATH=.installdir(.libdir.).)$/d' \
		-e 's:\<STAGING_PREFIX\>:SYSROOT:g' \
		SConstruct || die

	# Extract python info out of SConstruct so we can use saner distribute
	if use python ; then
		pyvar() { sed -n "/^ *$1 *=/s:.*= *::p" SConstruct ; }
		local pybins=$(pyvar python_progs)
		local pysrcs=$(sed -n '/^ *python_extensions = {/,/}/{s:^ *::;s:os[.]sep:"/":g;p}' SConstruct)
		local packet=$(python -c "${pysrcs}; print(python_extensions['gps/packet'])")
		local client=$(python -c "${pysrcs}; print(python_extensions['gps/clienthelpers'])")
		sed \
			-e "s|@VERSION@|$(pyvar gpsd_version)|" \
			-e "s|@URL@|$(pyvar website)|" \
			-e "s|@EMAIL@|$(pyvar devmail)|" \
			-e "s|@SCRIPTS@|${pybins}|" \
			-e "s|@GPS_PACKET_SOURCES@|${packet}|" \
			-e "s|@GPS_CLIENT_SOURCES@|${client}|" \
			-e "s|@SCRIPTS@|$(pyvar python_progs)|" \
			"${FILESDIR}"/${PN}-3.3-setup.py > setup.py || die
		distutils_src_prepare
	fi

	sed -i -e "s:/lib/udev:$(get_udevdir):" gpsd.rules SConstruct || die
}

src_configure() {
	myesconsargs=(
		prefix="${EPREFIX}/usr"
		libdir="\$prefix/$(get_libdir)"
		chrpath=False
		gpsd_user=gpsd
		gpsd_group=uucp
		strip=False
		python=False
		$(use_scons bluetooth bluez)
		$(use_scons cxx libgpsmm)
		$(use_scons debug)
		$(use_scons dbus dbus_export)
		$(use_scons ipv6)
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

	use python && distutils_src_compile
}

src_install() {
	DESTDIR="${D}" escons install $(usex udev udev-install "")

	newconfd "${FILESDIR}"/gpsd.conf-2 gpsd
	newinitd "${FILESDIR}"/gpsd.init-2 gpsd

	if use python ; then
		distutils_src_install
		# Delete all X related packages if user doesn't want them
		if ! use X ; then
			local p
			for p in $(grep -Il 'import .*pygtk' *) ; do
				find "${D}"/usr/bin -name "${p}*" -delete
			done
		fi
	fi
}

pkg_preinst() {
	# Run the gpsd daemon as gpsd and group uucp; create it here
	# as it doesn't seem to be needed during compile/install ...
	enewuser gpsd -1 -1 -1 "uucp"
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
