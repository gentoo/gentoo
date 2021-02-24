# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Safely remove spaces and strange characters from filenames"
HOMEPAGE="http://detox.sourceforge.net/ https://github.com/dharple/detox"
SRC_URI="https://github.com/dharple/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"/${MY_P}

RDEPEND="
	!dev-python/detox"

DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/flex
	sys-devel/bison
"

src_prepare() {
	default
	sed \
		-e '/detoxrc.sample/d' \
		-i Makefile.am || die
	eautoreconf
}

src_install() {
	default

	dodoc etc/${PN}rc.sample
}
