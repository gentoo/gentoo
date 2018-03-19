# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils systemd user readme.gentoo-r1

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="https://wiki.mumble.info"
if [[ "${PV}" = 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mumble-voip/mumble.git"
	EGIT_SUBMODULES=( '-*' )
else
	MY_P="mumble-${PV/_/~}"
	SRC_URI="https://mumble.info/snapshot/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+dbus debug +ice pch zeroconf"

RDEPEND="
	>=dev-libs/openssl-1.0.0b:0=
	>=dev-libs/protobuf-2.2.0:=
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	|| (
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtsql:5[mysql]
	)
	dev-qt/qtxml:5
	sys-apps/lsb-release
	>=sys-libs/libcap-2.15
	dbus? ( dev-qt/qtdbus:5 )
	ice? ( dev-libs/Ice:= )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"

DEPEND="${RDEPEND}
	>=dev-libs/boost-1.41.0
	virtual/pkgconfig"

DOC_CONTENTS="
	Useful scripts are located in /usr/share/doc/${PF}/scripts.\n
	Please execute:\n
	murmurd -ini /etc/murmur/murmur.ini -supw <pw>\n
	chown murmur:murmur /var/lib/murmur/murmur.sqlite\n
	to set the build-in 'SuperUser' password before starting murmur.
	Please restart dbus before starting murmur, or else dbus
	registration will fail.
"

pkg_setup() {
	enewgroup murmur
	enewuser murmur -1 -1 /var/lib/murmur murmur
}

src_prepare() {
	default

	sed \
		-e 's:mumble-server:murmur:g' \
		-e 's:/var/run:/run:g' \
		-i "${S}"/scripts/murmur.{conf,ini} || die
}

src_configure() {
	myuse() {
		[[ -n "${1}" ]] || die "myconf: No use flag given."
		use ${1} || echo "no-${1}"
	}
	local conf_add=(
		no-client
		$(myuse dbus)
		$(usex debug 'symbols debug' release)
		$(myuse ice)
		$(myuse pch)
		$(usex zeroconf '' no-bonjour)
	)

	eqmake5 main.pro -recursive \
		CONFIG+="${conf_add[*]}"
}

src_install() {
	dodoc README CHANGES

	docinto scripts
	dodoc -r scripts/server
	docompress -x /usr/share/doc/${PF}/scripts

	local dir
	if use debug; then
		dir=debug
	else
		dir=release
	fi

	dobin "${dir}"/murmurd

	insinto /etc/murmur/
	doins scripts/murmur.ini

	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/murmur.logrotate murmur

	insinto /etc/dbus-1/system.d/
	doins scripts/murmur.conf

	insinto /usr/share/murmur/
	doins src/murmur/Murmur.ice

	newinitd "${FILESDIR}"/murmur.initd-r1 murmur
	newconfd "${FILESDIR}"/murmur.confd murmur

	if use dbus; then
		systemd_newunit "${FILESDIR}"/murmurd-dbus.service "${PN}".service
		systemd_newtmpfilesd "${FILESDIR}"/murmurd-dbus.tmpfiles "${PN}".conf
	else
		systemd_newunit "${FILESDIR}"/murmurd-no-dbus.service "${PN}".service
	fi

	keepdir /var/lib/murmur /var/log/murmur
	fowners -R murmur /var/lib/murmur /var/log/murmur
	fperms 750 /var/lib/murmur /var/log/murmur

	# Fix permissions on config file as it might contain passwords.
	# (bug #559362)
	fowners root:murmur /etc/murmur/murmur.ini
	fperms 640 /etc/murmur/murmur.ini

	doman man/murmurd.1

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
