# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils autotools flag-o-matic

MY_PV="${PV//_beta/b}"
MY_PV="${MY_PV/_p/p}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="An automated suite of programs for configuring and maintaining
Unix-like computers"
HOMEPAGE="http://www.cfengine.org/"
SRC_URI="https://cfengine-package-repos.s3.amazonaws.com/tarballs/${MY_P}.tar.gz
	masterfiles? ( https://cfengine-package-repos.s3.amazonaws.com/tarballs/${PN}-masterfiles-${MY_PV}.tar.gz )"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~amd64"

IUSE="acl curl examples libvirt +lmdb mysql +masterfiles postgres qdbm selinux tokyocabinet vim-syntax xml yaml"

DEPEND="acl? ( virtual/acl )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	selinux? ( sys-libs/libselinux )
	tokyocabinet? ( dev-db/tokyocabinet )
	qdbm? ( dev-db/qdbm )
	lmdb? ( dev-db/lmdb )
	libvirt? ( app-emulation/libvirt )
	xml? ( dev-libs/libxml2:2  )
	curl? ( net-misc/curl )
	xml? ( dev-libs/libxml2:2  )
	yaml? ( dev-libs/libyaml )
	dev-libs/openssl
	dev-libs/libpcre"
RDEPEND="${DEPEND}"
PDEPEND="vim-syntax? ( app-vim/cfengine-syntax )"

REQUIRED_USE="^^ ( qdbm tokyocabinet lmdb )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	epatch "${FILESDIR}/${P}-logging-fix.patch"
	epatch "${FILESDIR}/${P}-ipv6-address.patch"
	eautoreconf
}

src_unpack() {
	unpack ${MY_P}.tar.gz
	if use masterfiles; then
		unpack ${PN}-masterfiles-${MY_PV}.tar.gz
		mv ${PN}-masterfiles-${MY_PV} masterfiles
	fi
}

src_configure() {
	# Enforce /var/cfengine for historical compatibility

	econf \
		--enable-fhs \
		--docdir=/usr/share/doc/${PF} \
		--with-workdir=/var/cfengine \
		--with-pcre \
		$(use_with acl libacl) \
		$(use_with qdbm) \
		$(use_with tokyocabinet) \
		$(use_with postgres postgresql) \
		$(use_with mysql mysql check) \
		$(use_with libvirt) \
		$(use_with curl libcurl) \
		$(use_with xml libxml2) \
		$(use_with yaml libyaml) \
		$(use_enable selinux)
}

src_install() {
	newinitd "${FILESDIR}"/cf-serverd.initd-${PV} cf-serverd || die
	newinitd "${FILESDIR}"/cf-monitord.initd-${PV} cf-monitord || die
	newinitd "${FILESDIR}"/cf-execd.initd-${PV} cf-execd || die

	emake DESTDIR="${D}" install || die

	# fix ifconfig path in provided promises
	find "${D}"/usr/share -name "*.cf" | xargs sed -i "s,/sbin/ifconfig,$(which ifconfig),g"

	dodoc AUTHORS

	if ! use examples; then
		rm -rf "${D}"/usr/share/doc/${PF}/example*
	fi

	# Create cfengine working directory
	dodir /var/cfengine/bin
	fperms 700 /var/cfengine

	# Copy cfagent into the cfengine tree otherwise cfexecd won't
	# find it. Most hosts cache their copy of the cfengine
	# binaries here. This is the default search location for the
	# binaries.
	for bin in promises agent monitord serverd execd runagent key; do
		dosym /usr/bin/cf-$bin /var/cfengine/bin/cf-$bin || die
	done

	if use masterfiles; then
		insinto /var/cfengine
		doins -r "${WORKDIR}/masterfiles"
	fi

	dodir /etc/env.d
	echo 'CONFIG_PROTECT=/var/cfengine/masterfiles' >"${ED}/etc/env.d/99${PN}" || die
}

pkg_postinst() {
	echo
	einfo "Init scripts for cf-serverd, cf-monitord, and cf-execd are provided."
	einfo
	einfo "To run cfengine out of cron every half hour modify your crontab:"
	einfo "0,30 * * * *    /usr/bin/cf-execd -F"
	echo

	elog "If you run cfengine the very first time, you MUST generate the keys for cfengine by running:"
	elog "emerge --config ${CATEGORY}/${PN}"
}

pkg_config() {
	if [ "${ROOT}" == "/" ]; then
		if [ ! -f "/var/cfengine/ppkeys/localhost.priv" ]; then
			einfo "Generating keys for localhost."
			/usr/bin/cf-key
		fi
	else
		die "cfengine cfkey does not support any value of ROOT other than /."
	fi
}
