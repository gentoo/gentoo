# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_BETA="$(ver_cut 6-)"
MY_PATCH="$(ver_cut 4-5)"
MY_PV="$(ver_cut 1-3)${MY_BETA/beta/b}"
inherit readme.gentoo-r1 systemd user

DESCRIPTION="Dynamic DNS client for lots of dynamic dns services"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://debian/pool/main/e/ez-ipupdate/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/e/ez-ipupdate/${PN}_${MY_PV}-${MY_PATCH}.diff.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Please create one or more config files in
/etc/ez-ipupdate/. A bunch of samples can
be found in the doc directory.

All config files must have a '.conf' extension.

If you are using openRC you need to:
- Please do not use the 'run-as-user', 'run-as-euser',
'cache-file' and 'pidfile' options, since these are
handled internally by the init-script.

-If you want to use ez-ipupdate in daemon mode,
please add 'daemon' to the config file(s) and
add the ez-ipupdate init-script to the default runlevel.
Without the 'daemon' option, you can run the
init-script with the 'update' parameter inside
your PPP ip-up script.
"

PATCHES=(
	# adding members.3322.org support
	"${FILESDIR}/${P}-3322.diff"
	# adding www.dnsexit.com support
	"${FILESDIR}/${P}-dnsexit.diff"
	# make ez-ipupdate work with iproute2/dhcpcd under linux (bug #318905)
	"${FILESDIR}/${P}-linux.diff"
	# allows to set IPv6 via -a option, (bug #432764)
	"${FILESDIR}/${P}-ipv6.diff"
	# repair format mask issues
	"${FILESDIR}/${P}-fix-format-mask.patch"
)

src_prepare() {
	# Debian patches
	eapply "${WORKDIR}/${PN}_${MY_PV}-${MY_PATCH}.diff"
	# repair/apply additional Debian patches
	sed -i -e "s|^\(---\s*\)\.\./|\1|g" debian/patches/*.diff || die
	eapply debian/patches

	default

	# comment out obsolete options
	sed -i -e "s:^\(run-as-user.*\):#\1:g" \
		-e "s:^\(cache-file.*\):#\1:g" ex*conf || die

	# make 'missing' executable (bug #103480)
	chmod +x missing || die
}

src_configure() {
	econf --bindir=/usr/sbin
}

src_install() {
	emake DESTDIR="${D}" install
	newinitd "${FILESDIR}/ez-ipupdate.initd" ez-ipupdate
	systemd_dounit "${FILESDIR}/${PN}.service"
	keepdir /etc/ez-ipupdate

	# install docs
	dodoc README
	newdoc debian/README.Debian README.debian
	newdoc debian/changelog ChangeLog.debian
	newdoc CHANGELOG ChangeLog
	doman debian/ez-ipupdate.8

	# install example configs
	docinto examples
	dodoc ex*conf

	readme.gentoo_create_doc
}

pkg_preinst() {
	enewgroup ez-ipupd
	enewuser ez-ipupd -1 -1 /var/cache/ez-ipupdate ez-ipupd
}

pkg_postinst() {
	chmod 750 /etc/ez-ipupdate /var/cache/ez-ipupdate || die
	chown ez-ipupd:ez-ipupd /etc/ez-ipupdate /var/cache/ez-ipupdate || die

	readme.gentoo_print_elog

	if [[ -f /etc/ez-ipupdate.conf ]]; then
		elog "The ez-ipupdate init-script can now handle more"
		elog "than one config file. New config file location is"
		elog "/etc/ez-ipupdate/*.conf"
		if [[ ! -f /etc/ez-ipupdate/default.conf ]]; then
			mv -f /etc/ez-ipupdate.conf /etc/ez-ipupdate/default.conf || die
			elog "Your old configuration has been moved to"
			elog "/etc/ez-ipupdate/default.conf"
		fi
	fi
}
