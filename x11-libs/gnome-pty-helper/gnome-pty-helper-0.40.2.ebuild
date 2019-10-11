# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME_ORG_MODULE="vte"

inherit gnome2

DESCRIPTION="GNOME Setuid helper for opening ptys"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/VTE"
# gnome-pty-helper is inside vte

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="+hardened"

# gnome-pty-helper was spit out with 0.27.90
RDEPEND="!<x11-libs/vte-0.27.90"
DEPEND=""

S="${WORKDIR}/vte-${PV}/gnome-pty-helper"

src_prepare() {
	# As recommended by upstream (/usr/libexec/$PN is a setgid binary)
	if use hardened; then
		export SUID_CFLAGS="-fPIE ${SUID_CFLAGS}"
		export SUID_LDFLAGS="-pie ${SUID_LDFLAGS}"
	fi
	gnome2_src_prepare
}
