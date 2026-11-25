# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODS="telnet"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for telnet"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DEPEND+="
	sec-policy/selinux-inetd[${SELINUX_POLICY_USEDEP}]
	sec-policy/selinux-remotelogin[${SELINUX_POLICY_USEDEP}]
"
RDEPEND+="
	sec-policy/selinux-inetd[${SELINUX_POLICY_USEDEP}]
	sec-policy/selinux-remotelogin[${SELINUX_POLICY_USEDEP}]
"
