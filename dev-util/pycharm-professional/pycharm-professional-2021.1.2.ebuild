# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop readme.gentoo-r1 xdg-utils

DESCRIPTION="Intelligent Python IDE with unique code assistance and analysis"
HOMEPAGE="http://www.jetbrains.com/pycharm/"
SRC_URI="http://download.jetbrains.com/python/${P}.tar.gz"

LICENSE="PyCharm_Academic PyCharm_Classroom PyCharm PyCharm_OpenSource PyCharm_Preview"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+bundled-jdk"

RDEPEND="!bundled-jdk? ( >=virtual/jre-1.8 )
	dev-libs/libdbusmenu
	dev-python/pip"

RESTRICT="mirror strip"

QA_PREBUILT="*"

MY_PN=${PN/-professional/}
S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	insinto /opt/${PN}
	doins -r *

	if use bundled-jdk; then
		fperms -R a+x /opt/pycharm-professional/jbr/bin/
	else
		rm -r "${D}"/opt/pycharm-professional/jbr/ || die
	fi

	fperms a+x /opt/${PN}/bin/{pycharm.sh,fsnotifier{,64},inspect.sh}

	dosym ../../opt/${PN}/bin/pycharm.sh /usr/bin/${PN}
	newicon bin/${MY_PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN}

	local rub

	for rub in aarch64 mips64el ppc64le; do
		rm -r "${D}"/opt/pycharm-professional/lib/pty4j-native/linux/${rub} || die
	done

	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
