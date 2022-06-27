# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm xdg

DESCRIPTION="JupyterLab desktop application, based on Electron"
HOMEPAGE="https://jupyter.org/"
SRC_URI="https://github.com/jupyterlab/${PN%%-bin}/releases/download/v$(ver_rs 3 -)/JupyterLab-Setup-Fedora.rpm -> ${P}.rpm"

KEYWORDS="-* ~amd64"
# Electron bundles a bunch of things
LICENSE="
	MIT BSD BSD-2 BSD-4 AFL-2.1 Apache-2.0 Ms-PL GPL-2 LGPL-2.1 APSL-2
	unRAR OFL CC-BY-SA-3.0 MPL-2.0 android public-domain all-rights-reserved
"
SLOT="0"

RDEPEND="
	app-accessibility/at-spi2-atk
	app-accessibility/at-spi2-core
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	dev-python/jupyterlab
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/libxshmfence
	x11-libs/pango
"

QA_PREBUILT="opt/JupyterLab/*"

S="${WORKDIR}"

src_install() {
	# remove files useless for Gentoo
	rm -r usr/lib || die
	mv "${S}"/* "${ED}" || die
	# add convenience symlink to launch from cli
	dosym ../JupyterLab/jupyterlab-desktop /opt/bin/jupyterlab-desktop
}

pkg_postinst() {
	xdg_pkg_postinst
	elog ""
	elog "On initial startup you will be prompted to select the python environment of"
	elog "your choice. Either select a specific python version, e.g. /usr/bin/pythonX.Y,"
	elog "or choose /usr/bin/python to follow the system wide setting in"
	elog "/etc/python-exec/python-exec.conf."
	elog "Please note that only python environments corresponding to the enabled"
	elog "PYTHON_TARGETS on dev-python/jupyterlab will work."
	elog ""
}
