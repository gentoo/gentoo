# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

IUSE=""
MODS="acpi"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for acpi"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

pkg_postinst() {
	# "apm" module got renamed to "acpi", must remove apm first
	# the contexts are okay even tho the modules are not
	# replaced in the same command (doesnt become unlabeled_t)
	for i in ${POLICY_TYPES}; do
		if semodule -s "${i}" -l | grep apm >/dev/null 2>&1; then
			semodule -s "${i}" -r apm
		fi
	done
	selinux-policy-2_pkg_postinst
}

pkg_postrm() {
	for i in ${POLICY_TYPES}; do
		if semodule -s "${i}" -l | grep apm >/dev/null 2>&1; then
			semodule -s "${i}" -r apm
		fi
	done
	selinux-policy-2_pkg_postrm
}
