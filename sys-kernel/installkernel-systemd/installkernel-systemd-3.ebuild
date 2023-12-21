# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Wrap kernel-install from systemd as installkernel"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	!sys-kernel/installkernel-gentoo
	|| (
		sys-apps/systemd[kernel-install(-)]
		sys-apps/systemd-utils[kernel-install(-)]
	)
"

src_install() {
	# we could technically use a symlink here but it would require
	# us to know the correct path, and that implies /usr merge problems
	into /
	newsbin - installkernel <<-EOF
		#!/usr/bin/env sh
		exec kernel-install add "\${1}" "\${2}" --verbose
	EOF

	exeinto /usr/lib/kernel/install.d/
	newexe "${FILESDIR}/${PN}-2-r2-00-00machineid-directory.install" \
		00-00machineid-directory.install
	newexe "${FILESDIR}/${PN}-3-10-copy-prebuilt.install" \
		10-copy-prebuilt.install
}
