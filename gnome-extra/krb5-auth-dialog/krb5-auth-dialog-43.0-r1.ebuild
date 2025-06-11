# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2 meson

DESCRIPTION="An application to acquire and list Kerberos tickets."
HOMEPAGE="https://gitlab.gnome.org/GNOME/krb5-auth-dialog/"
SRC_URI="https://download.gnome.org/sources/${PN}/$(ver_cut 1)/${P}.tar.xz"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	app-crypt/gcr:0=[gtk]
	dev-libs/glib:2
	sys-libs/pam
	x11-libs/gtk+:3
	|| (
		app-crypt/heimdal
		app-crypt/mit-krb5
	)
"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/itstool"

PATCHES=( "${FILESDIR}"/${P}-remove-postinstall-script.patch )
