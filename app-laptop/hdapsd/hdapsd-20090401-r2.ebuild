# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit linux-info readme.gentoo

DESCRIPTION="IBM ThinkPad Harddrive Active Protection disk head parking daemon"
HOMEPAGE="http://hdaps.sourceforge.net/"
SRC_URI="mirror://sourceforge/hdaps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

pkg_setup() {
	# We require the hdaps module which can either come from kernel sources
	# or from the tp_smapi package.
	if ! has_version app-laptop/tp_smapi[hdaps]; then
		CONFIG_CHECK="~SENSORS_HDAPS"
		ERROR_SENSORS_HDAPS="${P} requires app-laptop/tp_smapi (with hdaps USE enabled) or support for CONFIG_SENSORS_HDAPS enabled"
		linux-info_pkg_setup
	fi

	DOC_CONTENTS="You can change the default frequency by modifing /sys/devices/platform/hdaps/sampling_rate.
		You might need to enable shock protection manually by running:\n
		# echo -1 > /sys/block/DEVICE/device/unload_heads"
}

src_install() {
	emake DESTDIR="${ED}" install
	rm -rf "${ED}"/usr/share/doc/hdapsd
	dodoc ChangeLog README AUTHORS
	newconfd "${FILESDIR}"/hdapsd.conf.3 hdapsd
	newinitd "${FILESDIR}"/hdapsd.init.3 hdapsd
	readme.gentoo_create_doc
}

pkg_postinst(){
	[[ -z $(ls ${EROOT}/sys/block/*/queue/protect 2>/dev/null) ]] && \
	[[ -z $(ls ${EROOT}/sys/block/*/device/unload_heads 2>/dev/null) ]] && \
		ewarn "Your kernel does NOT support shock protection. Kernel 2.6.28 and above is recommended!"

	if ! has_version app-laptop/tp_smapi[hdaps]; then
		ewarn "Using the hdaps module provided by app-laptop/tp_smapi instead"
		ewarn "of the in-kernel driver is strongly recommended!"
	fi

	readme.gentoo_print_elog
}
