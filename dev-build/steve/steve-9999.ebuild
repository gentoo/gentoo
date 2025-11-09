# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 git-r3 systemd tmpfiles

DESCRIPTION="A simple jobserver for Gentoo"
HOMEPAGE="https://gitweb.gentoo.org/proj/steve.git/"
EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/steve.git"

LICENSE="GPL-2+"
SLOT="0"

python_install_all() {
	default

	systemd_dounit data/steve.service
	newtmpfiles data/steve.tmpfiles steve.conf
	newconfd data/steve.confd steve
	newinitd data/steve.initd steve
	insinto /etc/sandbox.d
	newins data/sandbox.conf 90steve
}

pkg_postinst() {
	tmpfiles_process steve.conf

	if ! grep -q -s -R -- --jobserver-auth "${EROOT}"/etc/portage/make.conf
	then
		elog "In order to use system-wide steve instance, enable the service:"
		elog
		elog "  systemctl enable steve"
		elog "  systemctl start steve"
		elog
		elog "Then add to your make.conf:"
		elog
		elog '  MAKEFLAGS="--jobserver-auth=fifo:/run/portage/jobserver"'
		elog '  NINJAOPTS=""'
		elog
		elog "You can use -l in NINJAOPTS but *do not* use -j, as it disables"
		elog "job server support."
	fi
}
