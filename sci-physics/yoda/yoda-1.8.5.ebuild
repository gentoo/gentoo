# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

DESCRIPTION="Yet more Objects for (High Energy Physics) Data Analysis"
HOMEPAGE="https://yoda.hepforge.org/"
SRC_URI="https://www.hepforge.org/archive/${PN}/${P^^}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="root"

RDEPEND="root? ( sci-physics/root:= )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P^^}"

src_configure() {
	econf \
		--disable-pyext \
		--disable-static \
		$(use_enable root)
}

src_test() {
	# PYTESTS and SHTESTS both require python tools
	emake check PYTESTS= SHTESTS=
}

src_install() {
	default
	newbashcomp "${ED}"/usr/share/YODA/yoda-completion yoda
	rm "${ED}"/usr/share/YODA/yoda-completion || die
	rm -r "${ED}"/usr/etc || die
}
