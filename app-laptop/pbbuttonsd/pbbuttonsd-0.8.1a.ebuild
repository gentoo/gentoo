# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Handles power management and special keys on laptops"
HOMEPAGE="http://pbbuttons.berlios.de"
SRC_URI="mirror://sourceforge/pbbuttons/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"
IUSE="acpi alsa doc ibam macbook oss static-libs"

RDEPEND="
	>=dev-libs/glib-2.6
	alsa? ( >=media-libs/alsa-lib-1.0 )
	macbook? (
		sys-apps/pciutils
		sys-libs/libsmbios
	)
"
DEPEND="
	 ${RDEPEND}
	doc? ( app-doc/doxygen )
"
PATCHES=(
	"${FILESDIR}/${PN}-0.8.1-cpufreq.patch"
	"${FILESDIR}/${PN}-0.8.1-fnmode.patch"
	"${FILESDIR}/${PN}-0.8.1-laptopmode.sh.patch"
	"${FILESDIR}/${PN}-0.8.1-lm.patch"
	"${FILESDIR}/${PN}-0.8.1-lz.patch"
)

src_prepare() {
	### Don't link with g++ if we don't use ibam
	if ! use ibam; then
		eapply "${FILESDIR}/${PN}-0.8.1-g++.patch"
	fi

	default

	eautoconf
}

src_configure() {
	# Fix crash bug on some systems
	replace-flags -O? -O1

	if use macbook; then
		laptop=macbook
	elif use x86 || use amd64; then
		if use acpi; then
			laptop=acpi
		else
			laptop=i386
		fi
	# Default to PowerBook
	else
		laptop=powerbook
	fi

	laptop=$laptop \
		econf \
		$(use_with alsa) \
		$(use_with doc doxygen_docs) \
		$(use_with ibam) \
		$(use_with oss)

}

src_compile() {
	# Thanks to Stefan Bruda for this workaround
	# Using -j1 fixes a parallel build issue with the docs
	if use doc; then
		emake -j1 AR="$(tc-getAR)"
	else
		emake AR="$(tc-getAR)"
	fi
}

src_install() {
	dodir /etc/power
	if use ibam; then
		dodir /var/lib/ibam
		keepdir /var/lib/ibam
	fi

	default

	use static-libs || rm "${D}"/usr/$(get_libdir)/libpbb.a

	newinitd "${FILESDIR}/pbbuttonsd.rc6" pbbuttonsd
	dodoc README
	use doc && dodoc -r doc/

	dodir /etc/power/resume.d
	keepdir /etc/power/resume.d
	dodir /etc/power/suspend.d
	keepdir /etc/power/suspend.d
	exeinto /etc/power/scripts.d
	doexe "${FILESDIR}"/wireless
	ln -s "${D}"/etc/power/scripts.d/wireless "${D}"/etc/power/resume.d/wireless
}

pkg_postinst() {
	if [ -e /etc/pbbuttonsd.conf ]; then
		ewarn "The pbbuttonsd.cnf file replaces /etc/pbuttonsd.conf with a new"
		ewarn "file (/etc/pbbuttonsd.conf) and a new format. Please check the"
		ewarn "manual page with 'man pbbuttonsd.cnf' for details."
		ewarn
	fi

	if use macbook; then
		ewarn "Macbook and Macbook Pro users should make sure to have applesmc"
		ewarn "loaded before starting pbbuttonsdm otherwise auto-adjustments"
		ewarn "will not work and pbbuttonsd may segfault."
		ewarn
	fi

	ewarn "Ensure that the evdev kernel module is loaded otherwise"
	ewarn "pbbuttonsd won't work. SysV IPC is also required."
	ewarn
	ewarn "If you need extra security, you can tell pbbuttonsd to only accept"
	ewarn "input from one user. You can set the userallowed option in"
	ewarn "/etc/pbbuttonsd.cnf to limit access."
	ewarn

	if use ibam; then
		elog "To properly initialize the IBaM battery database, you will"
		elog "need to perform a full discharge/charge cycle. For more"
		elog "details, please see the pbbuttonsd man page."
		elog
	fi

	elog "A script is now available to reset your wirless connection on resume."
	elog "Simply uncomment the commented command and set the correct device to"
	elog "use it. You can find the script in /etc/power/resume.d/wireless"

}
