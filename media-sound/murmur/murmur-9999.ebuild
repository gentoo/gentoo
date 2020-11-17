# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake systemd readme.gentoo-r1

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="https://wiki.mumble.info"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mumble-voip/mumble.git"
	EGIT_SUBMODULES=( '-*' )
else
	MY_PN="mumble"
	if [[ "${PV}" == *_pre* ]] ; then
		MY_P="${MY_PN}-${PV}"
		SRC_URI="https://dev.gentoo.org/~polynomial-c/dist/${MY_P}.tar.xz"
		S="${WORKDIR}/${MY_P}"
	else
		MY_PV="${PV/_/-}"
		MY_P="${MY_PN}-${MY_PV}"
		SRC_URI="https://github.com/mumble-voip/mumble/releases/download/${MY_PV}/${MY_P}.tar.gz
			https://dl.mumble.info/${MY_P}.tar.gz"
		S="${WORKDIR}/${MY_PN}-${PV/_*}"
	fi
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+dbus grpc +ice test zeroconf"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/murmur
	acct-user/murmur
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
	grpc? ( net-libs/grpc )
	ice? ( dev-libs/Ice:= )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"

DEPEND="${RDEPEND}
	>=dev-libs/boost-1.41.0
"
BDEPEND="
	acct-group/murmur
	acct-user/murmur
	virtual/pkgconfig
"

if [[ "${PV}" == *9999 ]] ; then
	# Required for the mkini.sh script which calls perl multiple times
	BDEPEND+="
		dev-lang/perl
	"
fi

DOC_CONTENTS="
	Useful scripts are located in /usr/share/doc/${PF}/scripts.\n
	Please execute:\n
	murmurd -ini /etc/murmur/murmur.ini -supw <pw>\n
	chown murmur:murmur /var/lib/murmur/murmur.sqlite\n
	to set the build-in 'SuperUser' password before starting murmur.
	Please restart dbus before starting murmur, or else dbus
	registration will fail.
"

src_prepare() {
	default

	if [[ "${PV}" == *9999 ]] ; then
		pushd scripts &>/dev/null || die
		./mkini.sh || die
		popd &>/dev/null || die
	fi

	sed \
		-e 's:mumble-server:murmur:g' \
		-e 's:/var/run:/run:g' \
		-i "${S}"/scripts/murmur.{conf,ini.system} || die

	# Adjust systemd service file to our config location #689208
	sed "s@/etc/${PN}\.ini@/etc/${PN}/${PN}.ini@" \
		-i scripts/${PN}.service || die

	cmake_src_prepare
}

src_configure() {
	myuse() {
		[[ -n "${1}" ]] || die "myconf: No use flag given."
		use ${1} || echo "no-${1}"
	}
	local mycmakeargs=(
		-DBUILD_TESTING="$(usex test)"
		-Dclient="OFF"
		-Ddbus="$(usex dbus)"
		-Dg15="OFF"
		-Dgrpc="$(usex grpc)"
		-Dice="$(usex ice)"
		-Doverlay="OFF"
		-Dserver="ON"
		-Dzeroconf="$(usex zeroconf)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc README.md CHANGES

	docinto scripts
	dodoc -r scripts/server
	docompress -x /usr/share/doc/${PF}/scripts

	local etcdir="/etc/murmur"
	insinto ${etcdir}
	newins scripts/${PN}.ini.system ${PN}.ini

	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/murmur.logrotate murmur

	insinto /etc/dbus-1/system.d/
	doins scripts/murmur.conf

	insinto /usr/share/murmur/
	doins src/murmur/Murmur.ice

	newinitd "${FILESDIR}"/murmur.initd-r1 murmur
	newconfd "${FILESDIR}"/murmur.confd murmur

	systemd_dounit scripts/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/murmurd-dbus.tmpfiles "${PN}".conf

	keepdir /var/lib/murmur /var/log/murmur
	fowners -R murmur /var/lib/murmur /var/log/murmur
	fperms 750 /var/lib/murmur /var/log/murmur

	# Fix permissions on config file as it might contain passwords.
	# (bug #559362)
	fowners root:murmur ${etcdir}/murmur.ini
	fperms 640 ${etcdir}/murmur.ini

	doman man/murmurd.1

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
