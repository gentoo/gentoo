# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils readme.gentoo-r1 xdg

DESCRIPTION="Intelligent Python IDE with unique code assistance and analysis"
HOMEPAGE="http://www.jetbrains.com/pycharm/"
SRC_URI="http://download.jetbrains.com/python/${P}.tar.gz"

LICENSE="Apache-2.0 BSD CDDL MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bundled-jdk"

RDEPEND="!bundled-jdk? ( >=virtual/jre-1.8 )
	dev-libs/libdbusmenu
	dev-python/pip"

RESTRICT="mirror strip"

QA_PREBUILT="*"

MY_PN=${PN/-community/}

src_install() {
	insinto /opt/${PN}
	doins -r *

	if use bundled-jdk; then
		fperms -R a+x /opt/pycharm-community/jbr/bin/
	else
		rm -r "${D}"/opt/pycharm-community/jbr/ || die
	fi

	local rub

	for rub in aarch64 mips64el ppc64le; do
		rm -r "${D}"/opt/pycharm-community/lib/pty4j-native/linux/${rub} || die
	done

	fperms a+x /opt/${PN}/bin/{pycharm.sh,fsnotifier{,64},inspect.sh}

	dosym ../../opt/${PN}/bin/pycharm.sh /usr/bin/${PN}
	newicon bin/${MY_PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN}

	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
