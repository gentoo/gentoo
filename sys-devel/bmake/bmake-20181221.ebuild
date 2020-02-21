# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MK_VER=20191111

DESCRIPTION="NetBSD's portable make"
HOMEPAGE="http://www.crufty.net/help/sjg/bmake.html"
SRC_URI="
	http://void.crufty.net/ftp/pub/sjg/${P}.tar.gz
	http://void.crufty.net/ftp/pub/sjg/mk-${MK_VER}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${PN}-20181221-fix-gcc10-fno-common.patch )

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
	cd unit-tests || die
	LC_ALL=C env -u A "${S}"/bmake -r -m all || die "tests compilation failed"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	FORCE_BSD_MK=1 SYS_MK_DIR=. \
		sh ../mk/install-mk -v -m 644 "${ED}"/usr/share/mk/${PN} \
		|| die "failed to install mk files"
}
