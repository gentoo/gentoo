# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Alarm Pinger"
HOMEPAGE="https://github.com/Jajcus/apinger/"
SRC_URI="https://github.com/Jajcus/apinger/archive/${PN^^}_${PV//./_}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	sys-devel/flex
	virtual/yacc
"
DOCS=( AUTHORS ChangeLog NEWS README TODO )
PATCHES=(
	"${FILESDIR}"/${PN}-0.4.1-fno-common.patch
	"${FILESDIR}"/${PN}-0.4.1-stray-backslash.patch
)
S="${WORKDIR}/${PN}-${PN^^}_${PV//./_}"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake -C src/ cfgparser1.h
	default
}

src_install() {
	default
	insinto /etc
	doins src/${PN}.conf
}
