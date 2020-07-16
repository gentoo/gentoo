# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="IP multicast routing daemon"
HOMEPAGE="https://troglobit.com/projects/mrouted/"
SRC_URI="https://github.com/troglobit/${PN}/releases/download/${PV}/${P}.tar.bz2"
LICENSE="Stanford GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="rsrr"
RESTRICT="test"

DEPEND="|| ( dev-util/yacc sys-devel/bison )"

src_prepare() {
	# Respect user CFLAGS, remove upstream optimisation and -Werror, do not
	# print command summaries, do print commands
	sed -i \
		-e '/^CFLAGS/{s|[[:space:]]=| +=|g;s|-O2||g;s|-Werror||g}' \
		-e '/@printf/d' \
		-e 's|^\t-@|\t-|g' \
		-e 's|^\t@|\t|g' \
		Makefile || die
	default
}

src_configure() {
	sh configure $(usex rsrr --enable-rsrr '')
	tc-export CC CXX
}

src_compile() {
	emake CC=$(tc-getCC) CXX=$(tc-getCXX)
}

src_install() {
	dobin mrouted
	dosbin mtrace mrinfo map-mbone
	doman mrouted.8 mtrace.8 mrinfo.8 map-mbone.8

	insinto /etc
	doins mrouted.conf
	newinitd "${FILESDIR}"/mrouted.rc mrouted
}
