# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
COMMIT=07f67364e66b9f686a5b15d0c516310fcc3c7c9b
MY_PV=$COMMIT

DESCRIPTION="Ganeti OS provider for simple images"
HOMEPAGE="https://github.com/ganeti/instance-simpleimage"
SRC_URI="https://github.com/ganeti/instance-simpleimage/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/instance-simpleimage-${MY_PV}"

src_install() {
	# Config
	keepdir /etc/ganeti/instance-simpleimage/default/
	keepdir /etc/ganeti/instance-simpleimage/default/hooks
	touch "${D}/etc/ganeti/instance-simpleimage/default/config"

	insinto /usr/share/ganeti/os/simpleimage
	doins ganeti_api_version parameters.list common.sh
	exeinto /usr/share/ganeti/os/simpleimage
	doexe create export import rename verify
	# This is moved into /etc because sysadmins are expected to modify it, and
	# add matching dirs for each variant in
	# /etc/ganeti/instance-simpleimage/$VARIANT/
	insinto /etc/ganeti/instance-simpleimage/
	doins variants.list
	dosym ../../../../../etc/ganeti/instance-simpleimage/variants.list \
		/usr/share/ganeti/os/simpleimage/variants.list

	# Docs
	dodoc README.md
	docinto example-hooks
	dodoc example-hooks/debian-cloud-image-config
}
