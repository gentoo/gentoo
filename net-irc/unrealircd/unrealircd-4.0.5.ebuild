# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils ssl-cert versionator multilib user

DESCRIPTION="An advanced Internet Relay Chat daemon"
HOMEPAGE="https://www.unrealircd.org/"
SRC_URI="https://www.unrealircd.org/${PN}$(get_version_component_range 1)/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~amd64-linux"
IUSE="class-nofakelag curl +extban-stacking +operoverride operoverride-verify +prefixaq
	showlistmodes shunnotices ssl topicisnuhost +usermod"

RDEPEND="ssl? ( dev-libs/openssl:= )
	curl? ( net-misc/curl[adns] )
	dev-libs/libpcre2
	dev-libs/tre
	>=net-dns/c-ares-1.7"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_pretend() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		version_is_at_least 4 "${v}" && continue
		ewarn "The configuration file format has changed since ${v}."
		ewarn "Please be prepared to manually update them and visit:"
		ewarn "https://www.unrealircd.org/docs/Upgrading_from_3.2.x"
		break
	done
}

pkg_setup() {
	enewuser unrealircd
}

src_prepare() {
	# QA check against bundled pkgs
	rm -r extras || die

	if use class-nofakelag; then
		sed -i -e 's:#undef\( FAKELAG_CONFIGURABLE\):#define\1:' include/config.h || die
	fi

	eapply_user
}

src_configure() {
	econf \
		--with-bindir="${EPREFIX}"/usr/bin \
		--with-cachedir="${EPREFIX}"/var/lib/${PN} \
		--with-confdir="${EPREFIX}"/etc/${PN} \
		--with-datadir="${EPREFIX}"/var/lib/${PN} \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-logdir="${EPREFIX}"/var/log/${PN} \
		--with-modulesdir="${EPREFIX}"/usr/"$(get_libdir)"/${PN}/modules \
		--with-pidfile="${EPREFIX}"/run/${PN}/ircd.pid \
		--with-tmpdir="${EPREFIX}"/var/lib/${PN}/tmp \
		--with-nick-history=2000 \
		--with-sendq=3000000 \
		--with-permissions=0640 \
		--with-fd-setsize=1024 \
		--with-system-cares \
		--with-system-pcre2 \
		--with-system-tre \
		--enable-dynamic-linking \
		$(use_enable curl libcurl "${EPREFIX}"/usr) \
		$(use_enable prefixaq) \
		$(use_enable ssl ssl "${EPREFIX}"/usr) \
		$(use_with showlistmodes) \
		$(use_with topicisnuhost) \
		$(use_with shunnotices) \
		$(use_with !operoverride no-operoverride) \
		$(use_with operoverride-verify) \
		$(use_with !usermod disableusermod) \
		$(use_with !extban-stacking disable-extendedban-stacking)
}

src_install() {
	keepdir /var/log/${PN}
	keepdir /var/lib/${PN}/tmp

	newbin src/ircd ${PN}

	(
		cd src/modules || die
		for subdir in $(find . -type d -print); do
			if [[ -n $(shopt -s nullglob; echo ${subdir}/*.so) ]]; then
				exeinto /usr/$(get_libdir)/${PN}/modules/"${subdir}"
				doexe "${subdir}"/*.so
			fi
		done
	)

	insinto /etc/${PN}
	# Purposefully omitting the examples/ and ssl/ subdirectories. ssl
	# is redundant with app-misc/ca-certificates and examples will all
	# be in docs anyway.
	doins -r doc/conf/{aliases,help}
	doins doc/conf/*.conf
	newins doc/conf/examples/example.conf ${PN}.conf
	use ssl && keepdir /etc/${PN}/ssl

	dodoc \
		doc/{Changes.old,Changes.older,RELEASE-NOTES} \
		doc/{Donation,translations.txt}

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r2 ${PN}

	# config should be read-only
	fperms -R 0640 /etc/${PN}
	fperms 0750 /etc/${PN}{,/aliases,/help}
	use ssl && fperms 0750 /etc/${PN}/ssl
	# state is editable but not owned by unrealircd directly
	fperms 0770 /var/log/${PN}
	fperms 0770 /var/lib/${PN}{,/tmp}
	fowners -R root:unrealircd /{etc,var/{lib,log}}/${PN}
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
				ebegin "Creating ""${EROOT}${dir}"" with correct permissions"
				install -d -m "${mode}" -o "${user}" -g "${group}" "${EROOT}${dir}" || die
				eend ${?}
			elif ! [[ ${REPLACING_VERSIONS} ]] || for v in ${REPLACING_VERSIONS}; do
					# If 3.2.10 ≤ ${REPLACING_VERSIONS}, then we update
					# existing permissions.
					version_is_at_least "${v}" 3.2.10 && break
				done; then
				ebegin "Correcting permissions of ""${EROOT}${dir}"" left by ${CATEGORY}/${PN}-${v}"
				chmod "${mode}" "${EROOT}${dir}" \
					&& chown ${user}:${group} "${EROOT}${dir}" \
					|| die "Unable to correct permissions of ${EROOT}${dir}"
				eend ${?}
			fi
		done
	}

	# unrealircd only needs to be able to read files in /etc/unrealircd.
	_unrealircd_dir_permissions root unrealircd 0750 etc/${PN}{,/aliases}

	# unrealircd needs to be able to create files in /var/lib/unrealircd
	# and /var/log/unrealircd.
	_unrealircd_dir_permissions root unrealircd 0770 var/{lib,log}/${PN}
}

pkg_postinst() {
	# Move docert call from src_install() to install_cert in pkg_postinst for
	# bug #201682
	if use ssl ; then
		if [[ ! -f "${EROOT}"etc/${PN}/ssl/server.cert.key ]]; then
			if [[ -f "${EROOT}"etc/${PN}/server.cert.key ]]; then
				ewarn "The location ${PN} looks for SSL certificates has changed"
				ewarn "from ${EROOT}etc/${PN} to ${EROOT}etc/${PN}/ssl."
				ewarn "Please move your existing certificates."
			else
				(
					umask 0037
					install_cert /etc/${PN}/ssl/server.cert
					chown unrealircd "${EROOT}"etc/${PN}/ssl/server.cert.*
					ln -snf server.cert.key "${EROOT}"etc/${PN}/ssl/server.key.pem
				)
			fi
		fi
	fi

	local unrealircd_conf="${EROOT}"etc/${PN}/${PN}.conf
	# Fix up the default cloak keys.
	if grep -qe '"and another one";$' "${unrealircd_conf}" && grep -qe '"aoAr1HnR6gl3sJ7hVz4Zb7x4YwpW";$' "${unrealircd_conf}"; then
		ebegin "Generating cloak-keys"
		local keys=(
			$(${PN} -k 2>&1 | tail -n 3)
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

	# Precreate ircd.tune and ircd.log with the correct ownership to
	# protect people from themselves when they run unrealircd as root
	# before trying the initscripts. #560790
	local f
	for f in "${EROOT}"var/{lib/${PN}/ircd.tune,log/${PN}/ircd.log}; do
		[[ -e ${f} ]] && continue
		ebegin "Precreating ${f} to set ownership"
		(
			umask 0037
			# ircd.tune must be seeded with content instead of being empty.
			if [[ ${f} == *ircd.tune ]]; then
				echo 0 > "${f}"
				echo 0 >> "${f}"
			fi
			touch "${f}"
		)
		chown unrealircd "${f}"
		eend $?
	done

	elog "UnrealIRCd will not run until you've set up /etc/unrealircd/unrealircd.conf"
	elog
	elog "You can also configure ${PN} start at boot with rc-update(1)."
	elog "It is recommended to run unrealircd as an unprivileged user."
	elog "The provided init.d script does this for you."
}
