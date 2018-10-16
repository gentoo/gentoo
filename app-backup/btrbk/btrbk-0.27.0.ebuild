# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/digint/btrbk.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://digint.ch/download/btrbk/releases/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Tool for creating snapshots and remote backups of btrfs subvolumes"
HOMEPAGE="https://digint.ch/btrbk/"
LICENSE="GPL-3+"
SLOT="0"
IUSE="+pv"

DEPEND=">=app-text/asciidoc-8.6.0
	app-text/xmlto"

RDEPEND="dev-lang/perl
	net-misc/openssh
	pv? ( sys-apps/pv )
	>=sys-fs/btrfs-progs-3.18.2"

src_install() {
	emake DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" SYSTEMDDIR="$(systemd_get_systemunitdir)" install
}
pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-0.26.0" ; then
		upgrade_0_26_0_warning="1"
	fi
}
pkg_postinst() {
	if [[ "${upgrade_0_26_0_warning}" == "1" ]]; then
		ewarn "If you are using raw targets, make sure to run the"
		ewarn "\"raw_suffix2sidecar\" utility in each target directory."
	fi
}
