# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic linux-info linux-mod autotools-utils readme.gentoo-r1 systemd

DESCRIPTION="Skyld AV: on-access scanning daemon for ClamAV using fanotify"
HOMEPAGE="http://xypron.github.io/skyldav/"

## github release tarball
MY_PV=${PV/_rc/rc}
MY_P="${PN}-${MY_PV}"
SRC_URI="https://github.com/xypron/skyldav/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

## selfmade tarball
#MY_PVR=${PVR/_rc/rc}
#MY_P="${PN}-${MY_PVR}"
#SRC_URI="http://dev.gentoo.org/~wschlich/src/${CATEGORY}/${PN}/${MY_P}.tar.gz"

## github commit tarball
#MY_GIT_COMMIT="49bdb5e710b5a77c38ceb87da6015afb7009f1f9"
#MY_P="xypron-${PN}-${MY_GIT_COMMIT:0:7}"
#SRC_URI="https://github.com/xypron/${PN}/tarball/${MY_GIT_COMMIT} -> ${PF}.tar.gz"

S="${WORKDIR}/${MY_P}"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="Apache-2.0"
IUSE="libnotify systemd"

RDEPEND=">=app-antivirus/clamav-0.97.8
	sys-apps/util-linux
	sys-libs/libcap
	libnotify? (
		media-libs/libcanberra[gtk]
		x11-libs/libnotify
		x11-libs/gtk+:2
	)"
DEPEND="${RDEPEND}
	sys-devel/autoconf-archive"

## autotools-utils.eclass settings
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( AUTHORS NEWS README )
PATCHES=(
	"${FILESDIR}/${P}-syslog.patch"
	"${FILESDIR}/${P}-examples.patch"
	"${FILESDIR}/${P}-conf-r1.patch"
)

pkg_setup() {
	linux-info_pkg_setup
	kernel_is ge 3 8 0 || die "Linux 3.8.0 or newer recommended"
	CONFIG_CHECK="FANOTIFY FANOTIFY_ACCESS_PERMISSIONS"
	check_extra_config

	## define contents for README.gentoo
	if use systemd; then
		DOC_CONTENTS='Skyld AV provides a systemd service.'$'\n'
		DOC_CONTENTS+='Please edit the systemd service config file to match your needs:'$'\n'
		DOC_CONTENTS+='/etc/systemd/system/skyldav.service.d/00gentoo.conf'$'\n'
		DOC_CONTENTS+='# systemctl daemon-reload'$'\n'
		DOC_CONTENTS+='# systemctl restart skyldav.service'$'\n'
		DOC_CONTENTS+='Example for enabling the Skyld AV service:'$'\n'
		DOC_CONTENTS+='# systemctl enable skyldav.service'$'\n'
	else
		DOC_CONTENTS='Skyld AV provides an init script for OpenRC.'$'\n'
		DOC_CONTENTS+='Please edit the init script config file to match your needs:'$'\n'
		DOC_CONTENTS+='/etc/conf.d/skyldav'$'\n'
		DOC_CONTENTS+='Example for enabling the Skyld AV init script:'$'\n'
		DOC_CONTENTS+='# rc-update add skyldav default'$'\n'
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_with libnotify notification)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	## install systemd service or OpenRC init scripts
	if use systemd; then
		systemd_newunit "${FILESDIR}/skyldav.service-r1" skyldav.service
		systemd_install_serviced "${FILESDIR}"/skyldav.service.conf
		systemd_newtmpfilesd "${FILESDIR}"/skyldav.tmpfilesd skyldav.conf
	else
		newinitd "${FILESDIR}/${PN}.initd" ${PN}
		newconfd "${FILESDIR}/${PN}.confd" ${PN}
	fi

	## create README.gentoo from ${DOC_CONTENTS}
	DISABLE_AUTOFORMATTING=1 readme.gentoo_create_doc
}

pkg_postinst() {
	## workaround for /usr/lib/tmpfiles.d/skyldav.conf
	## not getting processed until the next reboot
	if use systemd; then
		install -d -m 0755 -o root -g root /run/skyldav
	fi
}
