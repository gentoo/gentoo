# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE='threads(+)'

inherit dot-a distutils-r1 multiprocessing waf-utils systemd

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/NTPsec/ntpsec.git"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/ntpsec.asc
	inherit verify-sig
	SRC_URI="
		https://ftp.ntpsec.org/pub/releases/${P}.tar.gz
		verify-sig? ( https://ftp.ntpsec.org/pub/releases/${P}.tar.gz.asc )
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~x86"

	BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-ntpsec-20260731 )"
fi

DESCRIPTION="The NTP reference implementation, refactored"
HOMEPAGE="https://www.ntpsec.org/"

LICENSE="HPND MIT BSD-2 BSD CC-BY-SA-4.0"
SLOT="0"

NTPSEC_REFCLOCK=(
	oncore trimble truetime gpsd jjy generic spectracom
	shm pps hpgps zyfer arbiter nmea modem local
)

IUSE="${NTPSEC_REFCLOCK[@]} debug doc early heat libbsd nist ntpviz samba seccomp selinux smear test" #ionice
REQUIRED_USE="${PYTHON_REQUIRED_USE} nist? ( local )"
RESTRICT="!test? ( test )"

# net-misc/pps-tools oncore,pps
DEPEND="
	${PYTHON_DEPS}
	dev-libs/openssl:=
	dev-python/psutil[${PYTHON_USEDEP}]
	sys-libs/libcap
	libbsd? ( dev-libs/libbsd:0= )
	oncore? ( net-misc/pps-tools )
	pps? ( net-misc/pps-tools )
	seccomp? ( sys-libs/libseccomp )
"
RDEPEND="
	${DEPEND}
	!net-misc/ntp
	!net-misc/openntpd
	acct-group/ntp
	acct-user/ntp
	ntpviz? (
		media-fonts/liberation-fonts
		sci-visualization/gnuplot
	)
	selinux? ( sec-policy/selinux-ntp )
"
BDEPEND+="
	app-alternatives/yacc
	>=app-text/asciidoc-8.6.8
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
"

WAF_BINARY="${S}/waf"

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	elif use verify-sig ; then
		# Needed for downloaded waf which is unsigned
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.gz{,.asc}
	fi

	default
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/${PN}-1.1.9-remove-asciidoctor-from-config.patch"
		"${FILESDIR}/${PN}-1.2.2-logrotate.patch"
		"${FILESDIR}/${PN}-1.2.4-pep517-no-egg.patch"
		"${FILESDIR}/${PN}-1.2.4-s390x-tests.patch"
	)
	if ! use libbsd ; then
		PATCHES+=( "${FILESDIR}/${PN}-no-bsd.patch" )
	fi

	distutils-r1_src_prepare

	# Remove autostripping of binaries
	sed -i -e '/Strip binaries/d' wscript || die
	# remove extra default pool servers
	sed -i '/use-pool/s/^/#/' "${S}"/etc/ntp.d/default.conf || die
}

src_configure() {
	# endianness configure test fails otherwise
	lto-guarantee-fat

	local string_127=""
	local rclocks="";
	local CLOCKSTRING=""

	for refclock in ${NTPSEC_REFCLOCK[@]} ; do
		if use ${refclock} ; then
			string_127+="$refclock,"
		fi
	done
	CLOCKSTRING="`echo ${string_127}|sed 's|,$||'`"

	myconf=(
		--docdir="${EPREFIX}/usr/share/docs/${PF}"
		--htmldir="${EPREFIX}/usr/share/docs/${PF}/html"
		--nopyc
		--nopyo
		--notests
		--refclock="${CLOCKSTRING}"
		$(use_enable doc)
		$(usev early --enable-early-droproot)
		$(usev samba --enable-mssntp)
		$(usev seccomp --enable-seccomp)
		$(usev smear --enable-leap-smear)
		$(usev debug --enable-debug)
	)
	python_setup
	cp -v "${FILESDIR}/flit.toml" "pylib/pyproject.toml" || die
	waf-utils_src_configure "${myconf[@]}"
}

src_compile() {
	waf-utils_src_compile --notests

	ln -svf pylib build/main/ntp || die
	cd build/main || die
	distutils-r1_src_compile
}

src_test() {
	cd build/main || die
	distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" "${WAF_BINARY}" check -v -j $(makeopts_jobs) || die
}

src_install() {
	# Install heat generating scripts
	use heat && dosbin "${S}"/contrib/ntpheat{,usb}

	# Install the openrc files
	newinitd "${FILESDIR}"/ntpd.rc-r3 ntp
	newconfd "${FILESDIR}"/ntpd.confd ntp

	# Install the systemd unit file
	systemd_newunit "${FILESDIR}"/ntpd-r1.service ntpd.service

	# Prepare a directory for the ntp.drift file
	keepdir /var/lib/ntp
	fowners ntp:ntp /var/lib/ntp
	fperms 770 /var/lib/ntp

	# Ensure statsdir exists
	keepdir /var/log/ntpstats/

	# Install a logrotate script
	insinto /etc/logrotate.d/ntpd
	doins "${S}"/etc/logrotate-config.ntpd

	# Install the configuration file and sample configuration
	insinto /etc
	doins "${FILESDIR}"/ntp.conf
	doins -r "${S}"/etc/ntp.d/

	ln -svf pylib build/main/ntp || die
	distutils-r1_src_install
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
