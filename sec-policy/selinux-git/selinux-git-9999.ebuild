# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODS="git"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for git"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DEPEND+="sec-policy/selinux-apache[${SELINUX_POLICY_USEDEP}]"
RDEPEND+="
	${DEPEND}
	sec-policy/selinux-apache[${SELINUX_POLICY_USEDEP}]
"
