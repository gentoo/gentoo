# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/unrealircd/unrealircd-3.2.10.4.ebuild,v 1.4 2014/10/10 10:50:19 ago Exp $

EAPI=4

inherit eutils ssl-cert versionator multilib user

MY_P=Unreal${PV/_/-}

DESCRIPTION="An advanced Internet Relay Chat daemon"
HOMEPAGE="http://www.unrealircd.com/"
SRC_URI="http://www.unrealircd.com/downloads/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~amd64-linux"
IUSE="class-nofakelag curl ipv6 +extban-stacking +operoverride operoverride-verify +prefixaq
	showlistmodes shunnotices ssl topicisnuhost +usermod zlib"

RDEPEND="ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )
	curl? ( net-misc/curl[adns] )
	dev-libs/tre
	>=net-dns/c-ares-1.7"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	virtual/pkgconfig"

S=${WORKDIR}/Unreal${PV}

pkg_setup() {
	enewuser unrealircd
}

src_prepare() {
	# QA check against bundled pkgs
	rm extras/*.gz || die

	sed -i \
		-e "s:ircd\.pid:${EPREFIX}/var/run/unrealircd/ircd.pid:" \
		-e "s:ircd\.log:${EPREFIX}/var/log/unrealircd/ircd.log:" \
		-e "s:debug\.log:${EPREFIX}/var/log/unrealircd/debug.log:" \
		-e "s:ircd\.tune:${EPREFIX}/var/lib/unrealircd/ircd.tune:" \
		include/config.h \
		|| die "sed failed"

	if use class-nofakelag; then
		sed -i -e 's:#undef\( FAKELAG_CONFIGURABLE\):#define\1:' include/config.h || die
	fi
}

src_configure() {
	econf \
		--with-listen=5 \
		--with-dpath="${EPREFIX}"/etc/unrealircd \
		--with-spath="${EPREFIX}"/usr/bin/unrealircd \
		--with-nick-history=2000 \
		--with-sendq=3000000 \
		--with-bufferpool=18 \
		--with-permissions=0600 \
		--with-fd-setsize=1024 \
		--with-system-cares \
		--with-system-tre \
		--enable-dynamic-linking \
		$(use_enable curl libcurl "${EPREFIX}"/usr) \
		$(use_enable ipv6 inet6) \
		$(use_enable prefixaq) \
		$(use_enable ssl ssl "${EPREFIX}"/usr) \
		$(use_enable zlib ziplinks "${EPREFIX}"/usr) \
		$(use_with showlistmodes) \
		$(use_with topicisnuhost) \
		$(use_with shunnotices) \
		$(use_with !operoverride no-operoverride) \
		$(use_with operoverride-verify) \
		$(use_with !usermod disableusermod) \
		$(use_with !extban-stacking disable-extendedban-stacking)
}

src_install() {
	keepdir /var/{lib,log}/unrealircd

	newbin src/ircd unrealircd

	exeinto /usr/$(get_libdir)/unrealircd/modules
	doexe src/modules/*.so

	dodir /etc/unrealircd
	dosym /var/lib/unrealircd /etc/unrealircd/tmp

	insinto /etc/unrealircd
	doins {badwords.*,help,spamfilter,dccallow}.conf
	newins doc/example.conf unrealircd.conf

	insinto /etc/unrealircd/aliases
	doins aliases/*.conf

	local so_suffix=so
	[[ ${CHOST} == -*mingw* ]] && so_suffix=dll
	sed -i \
		-e s:src/modules:"${EPREFIX}"/usr/$(get_libdir)/unrealircd/modules: \
		-e '/loadmodule.*\.'${so_suffix}'/s;^//;;' \
		-e s:ircd\\.log:"${EPREFIX}"/var/log/unrealircd/ircd.log: \
		"${ED}"/etc/unrealircd/unrealircd.conf \
		|| die

	dodoc \
		Changes Donation Unreal.nfo \
		ircdcron/{ircd.cron,ircdchk} \
		|| die "dodoc failed"
	dohtml doc/*.html

	newinitd "${FILESDIR}"/unrealircd.initd unrealircd
	newconfd "${FILESDIR}"/unrealircd.confd-r1 unrealircd

	# config should be read-only
	fperms -R 0640 /etc/unrealircd{,/aliases}
	fperms 0750 /etc/unrealircd{,/aliases}
	# state is editable but not owned by unrealircd directly
	fperms 0770 /var/{lib,log}/unrealircd
	fowners -R root:unrealircd /{etc,var/{lib,log}}/unrealircd
}

pkg_preinst() {
	# Must pre-create directories; otherwise their permissions are lost
	# on installation.

	# Usage: _unrealircd_dir_permissions <user> <group> <mode> <dir>[, <dir>…]
	#
	# Ensure that directories are created with the correct permissions
	# before portage tries to merge them to the filesystem because,
	# otherwise, those directories are installed world-readable.
	#
	# If this is a first-time install, create those directories with
	# correct permissions before installing. Otherwise, update
	# permissions—but only if we are replacing an unrealircd ebuild at
	# least as old as net-irc/unrealircd-3.2.10. Portage handles normal
	# file permissions correctly, so no need for recursive
	# chmoding/chowning.
	_unrealircd_dir_permissions() {
		local user=${1} group=${2} mode=${3} dir v
		shift 3
		while dir=${1} && shift; do
			if [[ ! -d "${EROOT}${dir}" ]]; then
				ebegin "Creating ${EROOT}${dir} with correct permissions"
				install -d -m "${mode}" -o "${user}" -g "${group}" "${EROOT}${dir}" || die
				eend ${?}
			elif ! [[ ${REPLACING_VERSIONS} ]] || for v in ${REPLACING_VERSIONS}; do
					# If 3.2.10 ≤ ${REPLACING_VERSIONS}, then we update
					# existing permissions.
					version_is_at_least "${v}" 3.2.10 && break
				done; then
				ebegin "Correcting permissions of ${EROOT}${dir} left by ${CATEGORY}/${PN}-${v}"
				chmod "${mode}" "${EROOT}${dir}" \
					&& chown ${user}:${group} "${EROOT}${dir}" \
					|| die "Unable to correct permissions of ${EROOT}${dir}"
				eend ${?}
			fi
		done
	}

	# unrealircd only needs to be able to read files in /etc/unrealircd.
	_unrealircd_dir_permissions root unrealircd 0750 etc/unrealircd{,/aliases}

	# unrealircd needs to be able to create files in /var/lib/unrealircd
	# and /var/log/unrealircd.
	_unrealircd_dir_permissions root unrealircd 0770 var/{lib,log}/unrealircd
}

pkg_postinst() {
	# Move docert call from scr_install() to install_cert in pkg_postinst for
	# bug #201682
	if use ssl ; then
		if [[ ! -f "${EROOT}"/etc/unrealircd/server.cert.key ]]; then
			install_cert /etc/unrealircd/server.cert
			chown unrealircd "${EROOT}"/etc/unrealircd/server.cert.*
			chmod 0640 "${EROOT}"/etc/unrealircd/server.cert.*
			ln -snf server.cert.key "${EROOT}"/etc/unrealircd/server.key.pem
		fi
	fi

	local unrealircd_conf="${EROOT}"/etc/unrealircd/unrealircd.conf
	# Fix up the default cloak keys.
	if grep -qe '"and another one";$' "${unrealircd_conf}" && grep -qe '"aoAr1HnR6gl3sJ7hVz4Zb7x4YwpW";$' "${unrealircd_conf}"; then
		ebegin "Generating cloak-keys"
		local keys=(
			$(unrealircd -k 2>&1 | tail -n 3)
		)
		[[ -n ${keys[0]} || -n ${keys[1]} || -n ${keys[2]} ]]
		eend $?

		ebegin "Substituting cloak-keys into ${unrealircd_conf}"
		sed -i \
			-e '/cloak-keys/ {
n
s/"aoAr1HnR6gl3sJ7hVz4Zb7x4YwpW";/"'"${keys[0]}"'";/
n
s/"and another one";/"'"${keys[1]}"'";/
n
s/"and another one";/"'"${keys[2]}"'";/
}' \
			"${unrealircd_conf}"
		eend $?
	fi

	elog "UnrealIRCd will not run until you've set up /etc/unrealircd/unrealircd.conf"
	elog
	elog "You can find example cron scripts here:"
	elog "   /usr/share/doc/${PF}/ircd.cron.gz"
	elog "   /usr/share/doc/${PF}/ircdchk.gz"
	elog
	elog "You can also use /etc/init.d/unrealircd to start at boot"
}
