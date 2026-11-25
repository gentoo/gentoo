# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODS="crio"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for cri-o"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DEPEND+="
	sec-policy/selinux-kubernetes[${SELINUX_POLICY_USEDEP}]
	sec-policy/selinux-podman[${SELINUX_POLICY_USEDEP}]
"
RDEPEND+="
	sec-policy/selinux-kubernetes[${SELINUX_POLICY_USEDEP}]
	sec-policy/selinux-podman[${SELINUX_POLICY_USEDEP}]
"
