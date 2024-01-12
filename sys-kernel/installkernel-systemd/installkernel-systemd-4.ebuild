# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Wrap kernel-install from systemd as installkernel"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND=">=sys-kernel/installkernel-14"

pkg_setup() {
	elog "The wrapper functionality of ${PN} has been integrated into"
	elog "sys-kernel/installkernel[systemd]."
	elog "${PN} can be safely removed and replaced:"
	elog
	elog "emerge --noreplace sys-kernel/installkernel"
	elog "emerge --depclean sys-kernel/installkernel-systemd"
}
