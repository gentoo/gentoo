# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="Resource monitor that shows usage and stats"
HOMEPAGE="https://github.com/aristocratos/bashtop"
SRC_URI="https://github.com/aristocratos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	sed -i -e 's/local//g' Makefile || die "Editing path failed"
	sed -i -e '/DOCDIR/d' Makefile || die "Removing doc folder failed"
}

pkg_postinst() {
	optfeature "CPU Temperature support" sys-apps/lm-sensors
	optfeature "Update news and Theme Download feature" net-misc/curl
	optfeature "Disk Stats support" app-admin/sysstat
}
