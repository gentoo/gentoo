# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit autotools pam python-single-r1 systemd

DESCRIPTION="The FRRouting Protocol Suite"
HOMEPAGE="https://frrouting.org/"
SRC_URI="https://github.com/FRRouting/frr/archive/${P}.tar.gz"
# FRR tarballs have weird format.
S="${WORKDIR}/frr-${P}"

LICENSE="GPL-2+"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="doc fpm grpc nhrp ospfapi pam rpki snmp test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	${PYTHON_DEPS}
	acct-user/frr
	dev-libs/json-c:0=
	dev-libs/protobuf-c:0=
	>=net-libs/libyang-2.1.128
	sys-libs/libcap
	sys-libs/readline:0=
	virtual/libcrypt:=
	grpc? ( net-libs/grpc:= )
	nhrp? ( net-dns/c-ares:0= )
	pam? ( sys-libs/pam )
	rpki? ( >=net-libs/rtrlib-0.8.0[ssh] )
	snmp? ( net-analyzer/net-snmp:= )
"
BDEPEND="
	sys-devel/flex
	app-alternatives/yacc
	doc? ( dev-python/sphinx )
"
DEPEND="
	${COMMON_DEPEND}
	elibc_musl? ( sys-libs/queue-standalone )
	test? (
		$(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
		dev-util/cunit
	)
"
RDEPEND="
	${COMMON_DEPEND}
"

PATCHES=(
	"${FILESDIR}"/${PN}-7.5-ipctl-forwarding.patch
	"${FILESDIR}"/${PN}-8.4.1-logrotate.patch
	"${FILESDIR}"/${PN}-9.1-mimic-gnu-basename-api-for-non-glibc.patch
)

QA_CONFIG_IMPL_DECL_SKIP=(
	mallinfo # No functional impact.
	mallinfo2
)

src_prepare() {
	default

	python_fix_shebang tools
	eautoreconf
}

src_configure() {
	local myconf=(
		LEX=flex
		--with-pkg-extra-version="-gentoo"
		--enable-configfile-mask=0640
		--enable-logfile-mask=0640
		--libdir="${EPREFIX}"/usr/lib/frr
		--sbindir="${EPREFIX}"/usr/lib/frr
		--libexecdir="${EPREFIX}"/usr/lib/frr
		--sysconfdir="${EPREFIX}"/etc/frr
		--localstatedir="${EPREFIX}"/run/frr
		--with-moduledir="${EPREFIX}"/usr/lib/frr/modules
		--enable-user=frr
		--enable-group=frr
		--enable-vty-group=frr
		--enable-multipath=64
		$(use_enable doc)
		$(use_enable fpm)
		$(use_enable grpc)
		$(use_enable kernel_linux realms)
		$(use_enable nhrp nhrpd)
		$(usex ospfapi '--enable-ospfclient' '' '' '')
		$(use_enable rpki)
		$(use_enable snmp)
	)

	econf "${myconf[@]}"
}

src_compile() {
	default

	use doc && emake -C doc html
}

src_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	# Install user documentation if asked
	use doc && dodoc -r doc/user/_build/html

	# Create configuration directory with correct permissions
	# Create logs directory with the correct permissions
	diropts -ofrr -gfrr -m0775
	keepdir /var/log/frr /etc/frr

	# Install the default configuration files
	insinto /etc/frr
	doins tools/etc/frr/{vtysh.conf,frr.conf,daemons}

	# Fix permissions/owners.
	fowners frr:frr /etc/frr/{vtysh.conf,frr.conf,daemons}
	fperms 640 /etc/frr/{vtysh.conf,frr.conf,daemons}

	# Install logrotate configuration
	insinto /etc/logrotate.d
	newins redhat/frr.logrotate frr

	# Install PAM configuration file
	use pam && newpamd "${FILESDIR}"/frr.pam frr

	# Install init scripts
	systemd_dounit tools/frr.service
	newinitd "${FILESDIR}"/frr-openrc-v2 frr

	# Conflict files, installed by net-libs/libsmi, bug #758383
	# Files from frr seems to be newer.
	rm "${ED}"/usr/share/yang/ietf-interfaces.yang || die
	rm "${ED}"/usr/share/yang/ietf-netconf.yang || die
	rm "${ED}"/usr/share/yang/ietf-netconf-with-defaults.yang || die
	rm "${ED}"/usr/share/yang/ietf-netconf-acm.yang || die
}
