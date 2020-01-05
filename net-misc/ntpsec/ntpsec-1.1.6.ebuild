# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
PYTHON_REQ_USE='threads(+)'

inherit flag-o-matic python-r1 waf-utils systemd user

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/NTPsec/ntpsec.git"
	BDEPEND=""
	KEYWORDS=""
else
	SRC_URI="ftp://ftp.ntpsec.org/pub/releases/${PN}-${PV}.tar.gz"
	RESTRICT="mirror"
	BDEPEND=""
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="The NTP reference implementation, refactored"
HOMEPAGE="https://www.ntpsec.org/"

NTPSEC_REFCLOCK=(
	oncore trimble truetime gpsd jjy generic spectracom
	shm pps hpgps zyfer arbiter nmea neoclock modem
	local)

IUSE_NTPSEC_REFCLOCK=${NTPSEC_REFCLOCK[@]/#/rclock_}

LICENSE="HPND MIT BSD-2 BSD CC-BY-SA-4.0"
SLOT="0"
IUSE="${IUSE_NTPSEC_REFCLOCK} debug doc early gdb heat libbsd nist ntpviz samba seccomp smear tests" #ionice
REQUIRED_USE="${PYTHON_REQUIRED_USE} nist? ( rclock_local )"

# net-misc/pps-tools oncore,pps
CDEPEND="${PYTHON_DEPS}
	${BDEPEND}
	sys-libs/libcap
	dev-python/psutil[${PYTHON_USEDEP}]
	libbsd? ( dev-libs/libbsd:0= )
	dev-libs/openssl:0=
	seccomp? ( sys-libs/libseccomp )
"
RDEPEND="${CDEPEND}
	ntpviz? ( sci-visualization/gnuplot media-fonts/liberation-fonts )
	!net-misc/ntp
	!net-misc/openntpd
"
DEPEND="${CDEPEND}
	app-text/asciidoc
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	sys-devel/bison
	rclock_oncore? ( net-misc/pps-tools )
	rclock_pps? ( net-misc/pps-tools )
"

WAF_BINARY="${S}/waf"

pkg_setup() {
	enewgroup ntp 123
	enewuser ntp 123 -1 /dev/null ntp
}

src_prepare() {
	default
	# Remove autostripping of binaries
	sed -i -e '/Strip binaries/d' wscript
	if ! use libbsd ; then
		epatch "${FILESDIR}/${PN}-no-bsd.patch"
	fi
	python_copy_sources
}

src_configure() {
	is-flagq -flto* && filter-flags -flto* -fuse-linker-plugin

	local string_127=""
	local rclocks="";
	local CLOCKSTRING=""

	for refclock in ${NTPSEC_REFCLOCK[@]} ; do
		if use rclock_${refclock} ; then
			string_127+="$refclock,"
		fi
	done
	CLOCKSTRING="`echo ${string_127}|sed 's|,$||'`"

	local myconf=(
		--nopyc
		--nopyo
		--refclock="${CLOCKSTRING}"
		$(use doc	&& echo "--enable-doc")
		$(use early	&& echo "--enable-early-droproot")
		$(use gdb	&& echo "--enable-debug-gdb")
		$(use samba	&& echo "--enable-mssntp")
		$(use seccomp	&& echo "--enable-seccomp")
		$(use smear	&& echo "--enable-leap-smear")
		$(use tests	&& echo "--alltests")
		$(use debug	&& echo "--enable-debug")
	)

	python_configure() {
		waf-utils_src_configure "${myconf[@]}"
	}
	python_foreach_impl run_in_build_dir python_configure
}

src_compile() {
	unset MAKEOPTS
	python_compile() {
		waf-utils_src_compile
	}
	python_foreach_impl run_in_build_dir python_compile
}

src_install() {
	python_install() {
		waf-utils_src_install
	}
	python_foreach_impl run_in_build_dir python_install

	# Install heat generating scripts
	use heat && dosbin "${S}"/contrib/ntpheat{,usb}

	# Install the openrc files
	newinitd "${FILESDIR}"/ntpd.rc-r2 ntp
	newconfd "${FILESDIR}"/ntpd.confd ntp

	# Install the systemd unit file
	systemd_newunit "${FILESDIR}"/ntpd-r1.service ntpd.service

	# Prepare a directory for the ntp.drift file
	mkdir -pv "${ED}"/var/lib/ntp
	chown ntp:ntp "${ED}"/var/lib/ntp
	chmod 770 "${ED}"/var/lib/ntp
	keepdir /var/lib/ntp

	# Install a log rotate script
	mkdir -pv "${ED}"/etc/logrotate.d
	cp -v "${S}"/etc/logrotate-config.ntpd "${ED}"/etc/logrotate.d/ntpd

	# Install the configuration file and sample configuration
	cp -v "${FILESDIR}"/ntp.conf "${ED}"/etc/ntp.conf
	cp -Rv "${S}"/etc/ntp.d/ "${ED}"/etc/

	# move doc files to /usr/share/doc/"${P}"
	use doc && mv -v "${ED}"/usr/share/doc/"${PN}" "${ED}"/usr/share/doc/"${P}"/html
}

pkg_postinst() {
	einfo "If you want to serve time on your local network, then"
	einfo "you should disable all the ref_clocks unless you have"
	einfo "one and can get stable time from it.  Feel free to try"
	einfo "it but PPS probably won't work unless you have a UART"
	einfo "GPS that actually provides PPS messages."
}
