# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE='threads(+)'
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 flag-o-matic waf-utils systemd

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/NTPsec/ntpsec.git"
else
	SRC_URI="ftp://ftp.ntpsec.org/pub/releases/${P}.tar.gz"
	KEYWORDS="~amd64 arm arm64 ~riscv ~x86"
fi

DESCRIPTION="The NTP reference implementation, refactored"
HOMEPAGE="https://www.ntpsec.org/"

NTPSEC_REFCLOCK=(
	oncore trimble truetime gpsd jjy generic spectracom
	shm pps hpgps zyfer arbiter nmea modem local
)

IUSE_NTPSEC_REFCLOCK=${NTPSEC_REFCLOCK[@]/#/rclock_}

LICENSE="HPND MIT BSD-2 BSD CC-BY-SA-4.0"
SLOT="0"
IUSE="${IUSE_NTPSEC_REFCLOCK} debug doc early gdb heat libbsd nist ntpviz samba seccomp smear" #ionice
REQUIRED_USE="${PYTHON_REQUIRED_USE} nist? ( rclock_local )"

# net-misc/pps-tools oncore,pps
DEPEND="${PYTHON_DEPS}
	dev-libs/openssl:=
	dev-python/psutil[${PYTHON_USEDEP}]
	sys-libs/libcap
	libbsd? ( dev-libs/libbsd:0= )
	seccomp? ( sys-libs/libseccomp )
	rclock_oncore? ( net-misc/pps-tools )
	rclock_pps? ( net-misc/pps-tools )"
RDEPEND="${DEPEND}
	!net-misc/ntp
	!net-misc/openntpd
	acct-group/ntp
	acct-user/ntp
	ntpviz? ( sci-visualization/gnuplot media-fonts/liberation-fonts )"
BDEPEND=">=app-text/asciidoc-8.6.8
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	sys-devel/bison"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.9-remove-asciidoctor-from-config.patch"
)

WAF_BINARY="${S}/waf"

src_prepare() {
	default

	# Remove autostripping of binaries
	sed -i -e '/Strip binaries/d' wscript || die
	if ! use libbsd ; then
		eapply "${FILESDIR}/${PN}-no-bsd.patch"
	fi
	# remove extra default pool servers
	sed -i '/use-pool/s/^/#/' "${S}"/etc/ntp.d/default.conf || die

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

	myconf=(
		--notests
		--nopyc
		--nopyo
		--enable-pylib ext
		--refclock="${CLOCKSTRING}"
		#--build-epoch="$(date +%s)"
		$(use doc	|| echo "--disable-doc")
		$(use early	&& echo "--enable-early-droproot")
		$(use gdb	&& echo "--enable-debug-gdb")
		$(use samba	&& echo "--enable-mssntp")
		$(use seccomp	&& echo "--enable-seccomp")
		$(use smear	&& echo "--enable-leap-smear")
		$(use debug	&& echo "--enable-debug")
	)

	distutils-r1_src_configure
}

python_configure() {
	waf-utils_src_configure "${myconf[@]}"
}

python_compile() {
	waf-utils_src_compile --notests
}

python_test() {
	waf-utils_src_compile check
}

src_install() {
	distutils-r1_src_install

	# Install heat generating scripts
	use heat && dosbin "${S}"/contrib/ntpheat{,usb}

	# Install the openrc files
	newinitd "${FILESDIR}"/ntpd.rc-r3 ntp
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

python_install() {
	waf-utils_src_install --notests
	python_fix_shebang "${ED}"
	python_optimize
}

pkg_postinst() {
	einfo "If you want to serve time on your local network, then"
	einfo "you should disable all the ref_clocks unless you have"
	einfo "one and can get stable time from it.  Feel free to try"
	einfo "it but PPS probably won't work unless you have a UART"
	einfo "GPS that actually provides PPS messages."
}
