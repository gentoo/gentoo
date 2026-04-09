# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker udev

DESCRIPTION="SANE driver for Brother scanners (brscan5)"
HOMEPAGE="https://support.brother.com/g/b/index.aspx"
SRC_URI="https://download.brother.com/welcome/dlf104033/${PN}-$(ver_rs 3 -).amd64.deb"
S="${WORKDIR}/opt/brother/scanner/brscan5"

LICENSE="Brother"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror strip"

RDEPEND="
	dev-libs/libusb:1
	media-gfx/sane-backends
	net-dns/avahi[dbus]
	sys-apps/dbus
	virtual/libudev
"

QA_PREBUILT="opt/brother/*"

src_install() {
	local brscan=/opt/brother/scanner/brscan5

	# Install the full Brother scanner tree to /opt
	insinto ${brscan}
	doins -r *

	# Mark executables
	fperms 0755 ${brscan}/{brsaneconfig5,brscan_cnetconfig,setupSaneScan5}

	# Mark libraries executable
	find "${ED}"${brscan} -name '*.so*' -exec chmod 0755 {} + || die

	# Internal Brother libraries are dlopen'd by the SANE backend at runtime.
	# Make them discoverable via ld.so.conf.d rather than symlinking into /usr/lib64.
	insinto /etc/ld.so.conf.d
	newins - 50-${PN}.conf <<< ${brscan}

	# SANE's dll backend searches only LIBDIR (/usr/lib64/sane/) for backend
	# .so files via fopen(), ignoring the ld.so cache. This symlink is needed
	# even with ld.so.conf.d above.
	# https://gitlab.com/sane-project/backends/-/blob/1.4.0/backend/dll.c#L482
	dosym -r ${brscan}/libsane-brother5.so.1.0.7 \
		/usr/lib64/sane/libsane-brother5.so.1

	# SANE dll.d configuration
	insinto /etc/sane.d/dll.d
	newins - ${PN} <<< brother5

	# brscan5 configuration
	insinto /etc/opt/brother/scanner/brscan5
	doins brscan5.ini
	doins brsanenetdevice.cfg

	# User-facing binary symlink
	dosym -r ${brscan}/brsaneconfig5 /usr/bin/brsaneconfig5

	# udev rules (strip deprecated SYSFS entries, install with clean name)
	sed -i '/SYSFS/d' udev-rules/NN-brother-mfp-brscan5-1.0.2-2.rules || die
	udev_newrules udev-rules/NN-brother-mfp-brscan5-1.0.2-2.rules 40-${PN}.rules
}

pkg_postinst() {
	udev_reload

	# https://bugs.gentoo.org/961463
	ldconfig -X

	# HOSTNAME is "BRW" followed by MAC for wi-fi
	# HOSTNAME is "BRN" followed by MAC for etherent
	elog "Your scanner's HOSTNAME can be discovered via avahi:"
	elog "  avahi-browse -rt _scanner._tcp"
	elog "To connect a network scanner using network discovery:"
	elog "  brsaneconfig5 -a name=SCANNER model=MODEL nodename=HOSTNAME.local"
}

pkg_postrm() {
	udev_reload

	# https://bugs.gentoo.org/961463
	ldconfig -X
}
