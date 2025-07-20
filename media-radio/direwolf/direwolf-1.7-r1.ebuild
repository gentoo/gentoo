# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd udev

DESCRIPTION="Decoded Information from Radio Emissions for Windows Or Linux Fans"
HOMEPAGE="https://github.com/wb2osz/direwolf/blob/master/README.md"
SRC_URI="https://github.com/wb2osz/direwolf/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="gps hamlib test udev"
RESTRICT="!test? ( test )"

RDEPEND="
	net-dns/avahi
	media-libs/alsa-lib
	gps? ( sci-geosciences/gpsd:= )
	hamlib? ( media-libs/hamlib:= )
	udev? ( virtual/libudev:= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6-use-standard-doc-dir.patch
	"${FILESDIR}"/${PN}-1.7-cmake4.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_GPSD=$(usex !gps)
		-DCMAKE_DISABLE_FIND_PACKAGE_hamlib=$(usex !hamlib)
		-DCMAKE_DISABLE_FIND_PACKAGE_udev=$(usex !udev)
		-DUNITTEST=$(usex test)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Fix udev rule installation path
	udev_dorules "${ED}"/etc/udev/rules.d/99-direwolf-cmedia.rules
	rm "${ED}"/etc/udev/rules.d/99-direwolf-cmedia.rules || die

	keepdir /var/log/direwolf

	# Pre-CMake, we installed a default config to /etc/direwolf.
	# Should we do that now?
	#insinto /etc/direwolf/
	#doins direwolf.conf

	systemd_dounit "${FILESDIR}"/direwolf.service
	systemd_dounit "${FILESDIR}"/direwolf-kiss.service
}

pkg_postinst() {
	udev_reload
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		einfo "The default configuration files are at:"
		einfo " - ${EROOT}/usr/share/doc/${PF}/conf/direwolf.conf"
		einfo " - ${EROOT}/usr/share/doc/${PF}/conf/sdr.conf"
		einfo "Copy these to the /etc/direwolf/ directory to modify them."
	fi
}

pkg_postrm() {
	udev_reload
}
