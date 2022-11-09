# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"

inherit chromium-2 desktop rpm xdg

DESCRIPTION="JupyterLab desktop application, based on Electron"
HOMEPAGE="https://jupyter.org/"
SRC_URI="https://github.com/jupyterlab/${PN%%-bin}/releases/download/v$(ver_rs 3 -)/JupyterLab-Setup-Fedora.rpm -> ${P}.rpm"
S="${WORKDIR}"

KEYWORDS="-* ~amd64"
# Electron bundles a bunch of things
LICENSE="
	MIT BSD BSD-2 BSD-4 AFL-2.1 Apache-2.0 Ms-PL GPL-2 LGPL-2.1 APSL-2
	unRAR OFL CC-BY-SA-3.0 MPL-2.0 android public-domain all-rights-reserved
"
SLOT="0"
RESTRICT="bindist mirror"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	>=dev-python/jupyterlab-$(ver_cut 1-3)
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

pkg_pretend() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	# cleanup languages
	pushd "opt/JupyterLab/locales" || die
	chromium_remove_language_paks
	popd || die
}

src_configure() {
	chromium_suid_sandbox_check_kernel_config
	default
}

src_install() {
	for size in {16,32,48,64,128,256,512}; do
		doicon -s ${size} "usr/share/icons/hicolor/${size}x${size}/apps/jupyterlab-desktop.png"
	done

	domenu usr/share/applications/jupyterlab-desktop.desktop

	local DESTDIR="/opt/JupyterLab"
	pushd "opt/JupyterLab" || die

	exeinto "${DESTDIR}"
	doexe chrome-sandbox chrome_crashpad_handler jupyterlab-desktop *.so*

	exeinto "${DESTDIR}/swiftshader"
	doexe swiftshader/*.so*

	insinto "${DESTDIR}"
	doins *.pak *.bin *.json *.dat
	insopts -m0755
	doins -r locales resources

	# Chrome-sandbox requires the setuid bit to be specifically set.
	# see https://github.com/electron/electron/issues/17972
	fperms 4755 "${DESTDIR}"/chrome-sandbox

	dosym "${DESTDIR}"/jupyterlab-desktop /opt/bin/jupyterlab-desktop
	popd || die
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
