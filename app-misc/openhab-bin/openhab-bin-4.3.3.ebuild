# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo systemd tmpfiles

MY_PN=${PN%-bin}
MY_P=${MY_PN}-${PV}
MY_CLI_VER=2024-01-14

DESCRIPTION="An open-source automation software for your home"
HOMEPAGE="https://www.openhab.org/"
SRC_URI="
	https://github.com/openhab/openhab-distro/releases/download/${PV}/${MY_P}.tar.gz
	https://raw.githubusercontent.com/openhab/openhab-linuxpkg/10061acd36524afb12a033fea6dcf142b399bf56/resources/usr/bin/openhab-cli
		 -> openhab-cli-${MY_CLI_VER}
"

S="${WORKDIR}"
LICENSE="EPL-2.0"
SLOT="0"

KEYWORDS="~amd64 ~arm64"

MY_JAVA_DEPEND=">=virtual/jre-17"

# app-arch/zip: used by "openhab-cli backup"
RDEPEND="
	${MY_JAVA_DEPEND}
	acct-user/openhab
	app-arch/zip
	dev-java/java-config
"

BDEPEND="app-arch/unzip"

src_compile() {
	:
}

src_install() {
	# We use move here to preserve the executable bit on the files under
	# openhab/runtime/bin.
	domove() {
		local source="${1}"
		local target="${2}"

		local dest="${ED}/${target}"

		mkdir -p "${dest}" || die "Failed to create ${dest}"
		mv "${source}"/* "${dest}" || die "Failed to move"
	}

	domove runtime /usr/share/openhab/runtime
	domove conf /etc/openhab

	domove userdata /var/lib/openhab
	fowners -R openhab:openhab /var/lib/openhab

	local dirs=(
		/usr/share/openhab/addons
		/var/log/openhab
	)
	local d
	for d in "${dirs[@]}"; do
		keepdir "${d}"
		fowners openhab:openhab "${d}"
	done

	newenvd "${FILESDIR}"/openhab.env 50openhab

	systemd_dounit "${FILESDIR}"/openhab.service
	newtmpfiles "${FILESDIR}"/openhab.tmpfiles openhab.conf

	newbin - openhab <<EOF
#!/usr/bin/env bash
set -eu

if [[ -v JAVA_HOME_OVERRIDE ]]; then
	JAVA_HOME="\${JAVA_HOME_OVERRIDE}"
else
	if ! GENTOO_JAVA_VM="\$(depend-java-query --get-vm '${MY_JAVA_DEPEND}')"; then
		>&2 echo "Could not find Java VM for ${MY_JAVA_DEPEND}"
	exit 1
	fi

	if ! JAVA_HOME_ASSIGNMENT=\$(java-config -P \${GENTOO_JAVA_VM} | grep JAVA_HOME); then
		>&2 echo "Could not retrieve JAVA_HOME of \${GENTOO_JAVA_VM}"
		exit 1
	fi

	eval \${JAVA_HOME_ASSIGNMENT}
fi

export JAVA_HOME
exec /usr/share/openhab/runtime/bin/karaf "\$@"
EOF
	newbin "${DISTDIR}"/openhab-cli-${MY_CLI_VER} openhab-cli

	newinitd "${FILESDIR}"/openhab.initd openhab
}

pkg_postinst() {
	tmpfiles_process openhab.conf

	if [[ -z ${REPLACING_VERSIONS} && -z ${OPENHAB_POSTINST_UPDATE} ]]; then
	   return
	fi

	if [[ -d "${EROOT}"/run/systemd/system ]]; then
		if systemctl is-active --quiet openhab; then
			local openhab_service_active=1
			einfo "Restarting OpenHAB service due to version update"
			edob systemctl daemon-reload
			edob systemctl stop openhab
		fi

		echo y | edob -m "Cleaning OpenHAB cache" \
					  openhab-cli clean-cache
		assert "Failed to clean OpenHAB cache"

		if [[ -v openhab_service_active ]]; then
			edob systemctl start openhab
		fi
	elif [[ -d /run/openrc ]]; then
		einfo "Follow these steps to complete the update of OpenHAB:"
		einfo
		einfo "1. Stop the OpenHAB's service"
		einfo "$ rc-service openhab stop"
		einfo "2. Clean OpenHAB's cache"
		einfo "$ openahb-cli clean-cache"
		einfo "3. Restart OpenHAB's service"
		einfo "$ rc-service openhab start"
	fi
}
