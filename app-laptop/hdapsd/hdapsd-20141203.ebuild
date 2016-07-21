# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit linux-info readme.gentoo systemd

DESCRIPTION="IBM ThinkPad Hard Drive Active Protection System (HDAPS) daemon"
HOMEPAGE="https://github.com/evgeni/${PN}/"
SRC_URI="https://github.com/evgeni/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libconfig"

DEPEND="libconfig? ( dev-libs/libconfig )"
RDEPEND="${DEPEND}"

pkg_setup() {
	# We require the hdaps module which can either come from either the
	# kernel itself (CONFIG_SENSORS_HDAPS) or from the tp_smapi package.
	if ! has_version app-laptop/tp_smapi[hdaps]; then
		CONFIG_CHECK="~SENSORS_HDAPS"
		ERROR_SENSORS_HDAPS="${P} requires app-laptop/tp_smapi[hdaps] or "
		ERROR_SENSORS_HDAPS+="kernel support for CONFIG_SENSORS_HDAPS enabled"
		linux-info_pkg_setup
	fi
}

src_configure(){
	econf \
		$(use_enable libconfig) \
		--with-systemdsystemunitdir=$(systemd_get_unitdir) \
		--docdir="/usr/share/doc/${PF}"
}

src_install() {
	default
	newconfd "${FILESDIR}/hdapsd.conf-20141024" hdapsd
	newinitd "${FILESDIR}/hdapsd.init-20141024" hdapsd
	readme.gentoo_create_doc
}

pkg_postinst(){
	[[ -z $(ls "${ROOT}"sys/block/*/queue/protect 2>/dev/null) ]] && \
	[[ -z $(ls "${ROOT}"sys/block/*/device/unload_heads 2>/dev/null) ]] && \
		ewarn "Your kernel does NOT support shock protection."

	readme.gentoo_print_elog
}

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="
${PN} requires a kernel module to function properly. The recommended
approach is to install app-laptop/tp_smapi[hdaps], but the in-tree
module provided by CONFIG_SENSORS_HDAPS may work as well.

Common daemon parameters can be set in ${EROOT}etc/conf.d/${PN}. If the
package was installed with USE=libconfig, then the parameters can also
be set in ${EROOT}etc/${PN}.conf, although the former will take
precedence over the latter if both are used.

You can change the default sampling rate by modifing

  /sys/devices/platform/hdaps/sampling_rate

and you may need to enable shock protection manually by running

  # echo -1 > /sys/block/<disk>/device/unload_heads

as root.
"
