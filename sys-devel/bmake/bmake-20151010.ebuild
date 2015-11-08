# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MK_VER=${PV}
DESCRIPTION="NetBSD's portable make"
HOMEPAGE="http://www.crufty.net/help/sjg/bmake.html"
SRC_URI="http://void.crufty.net/ftp/pub/sjg/${P}.tar.gz
		http://void.crufty.net/ftp/pub/sjg/mk-${MK_VER}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x64-freebsd"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_configure() {
	econf \
		--with-mksrc=../mk \
		--with-default-sys-path="${EPREFIX}"/usr/share/mk/${PN} \
		--with-machine_arch=${ARCH}
}

src_compile() {
	sh make-bootstrap.sh || die "bootstrap failed"
}

src_test() {
	cd unit-tests
	LC_ALL=C env -u A ${S}/bmake -r -m . > test.out 2>&1 \
		|| die "tests compilation failed"
	sed -i \
		-e "s:${S}/::g" \
		-e "s:bmake\\[.\\]:make:g" \
		-e "s:unit-tests/::g" \
		test.out || die "Fixing values failed"
	diff -u test.exp test.out
	[[ $(diff -u test.exp test.out |wc -l) -gt 0 ]] && die "tests differ"
}

src_install() {
	dobin ${PN}
	newman ${PN}.cat1 ${PN}.1
	FORCE_BSD_MK=1 SYS_MK_DIR=. \
		sh ../mk/install-mk -v -m 644 "${ED}"/usr/share/mk/${PN} \
		|| die "failed to install mk files"
}
