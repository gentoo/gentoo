# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit autotools pam python-single-r1 systemd

DESCRIPTION="The FRRouting Protocol Suite"
HOMEPAGE="https://frrouting.org/"
SRC_URI="https://github.com/FRRouting/frr/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc fpm grpc ipv6 kernel_linux nhrp ospfapi pam rpki snmp systemd"

COMMON_DEPEND="
	acct-user/frr
	dev-libs/json-c:0=
	>=net-libs/libyang-1.0.184
	sys-libs/libcap
	sys-libs/readline:0=
	grpc? ( net-libs/grpc )
	nhrp? ( net-dns/c-ares:0= )
	pam? ( sys-libs/pam )
	rpki? ( >=net-libs/rtrlib-0.6.3[ssh] )
	snmp? ( net-analyzer/net-snmp )
"

BDEPEND="
	${COMMON_DEPEND}
	doc? ( dev-python/sphinx )
	sys-devel/flex
	virtual/yacc
"

DEPEND="
	${PYTHON_DEPS}
	${COMMON_DEPEND}
"

RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep 'dev-python/ipaddr[${PYTHON_USEDEP}]')
	!!net-misc/quagga
"

PATCHES=(
	"${FILESDIR}/${PN}-7.5-ipctl-forwarding.patch"
)

# FRR tarballs have weird format.
S="${WORKDIR}/frr-${P}"

src_prepare() {
	default

	python_fix_shebang tools
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--with-pkg-extra-version="-gentoo" \
		--enable-configfile-mask=0640 \
		--enable-logfile-mask=0640 \
		--prefix=/usr \
		--libdir=/usr/lib/frr \
		--sbindir=/usr/lib/frr \
		--libexecdir=/usr/lib/frr \
		--sysconfdir=/etc/frr \
		--localstatedir=/run/frr \
		--with-moduledir=/usr/lib/frr/modules \
		--enable-exampledir=/usr/share/doc/${PF}/samples \
		--enable-user=frr \
		--enable-group=frr \
		--enable-vty-group=frr \
		--enable-multipath=64 \
		$(use_enable doc) \
		$(use_enable fpm) \
		$(use_enable grpc) \
		$(use_enable ipv6 ospf6d) \
		$(use_enable ipv6 ripngd) \
		$(use_enable ipv6 rtadv) \
		$(use_enable kernel_linux realms) \
		$(use_enable nhrp nhrpd) \
		$(usex ospfapi '--enable-ospfclient' '' '' '') \
		$(use_enable rpki) \
		$(use_enable snmp) \
		$(use_enable systemd)
}

src_compile() {
	default

	use doc && (cd doc; make html)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	# Install user documentation if asked
	use doc && dodoc -r doc/user/_build/html

	# Create configuration directory with correct permissions
	keepdir /etc/frr
	fowners frr:frr /etc/frr
	fperms 775 /etc/frr

	# Create logs directory with the correct permissions
	keepdir /var/log/frr
	fowners frr:frr /var/log/frr
	fperms 775 /var/log/frr

	# Install the default configuration files
	insinto /etc/frr
	doins tools/etc/frr/vtysh.conf
	doins tools/etc/frr/frr.conf
	doins tools/etc/frr/daemons

	# Fix permissions/owners.
	fowners frr:frr /etc/frr/vtysh.conf
	fowners frr:frr /etc/frr/frr.conf
	fowners frr:frr /etc/frr/daemons
	fperms 640 /etc/frr/vtysh.conf
	fperms 640 /etc/frr/frr.conf
	fperms 640 /etc/frr/daemons

	# Install logrotate configuration
	insinto /etc/logrotate.d
	newins redhat/frr.logrotate frr

	# Install PAM configuration file
	use pam && newpamd "${FILESDIR}/frr.pam" frr

	# Install init scripts
	systemd_dounit tools/frr.service
	newinitd "${FILESDIR}/frr-openrc-v1" frr
}
