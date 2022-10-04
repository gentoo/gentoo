# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MK_VER=20210330

DESCRIPTION="NetBSD's portable make"
HOMEPAGE="http://www.crufty.net/help/sjg/bmake.html"
SRC_URI="
	http://void.crufty.net/ftp/pub/sjg/${P}.tar.gz
	http://void.crufty.net/ftp/pub/sjg/mk-${MK_VER}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

# Skip failing test (sandbox and csh)
PATCHES=(
	"${FILESDIR}"/${PN}-20210206-tests.patch
	"${FILESDIR}"/${PN}-20220418-warnings.patch
)

src_prepare() {
	default
	cd "${WORKDIR}" || die
	eapply "${FILESDIR}"/${PN}-20210314-mk-fixes.patch
}

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

	# the 'ternary' test uses ${A} internally, which
	# conflicts with Gentoo's ${A}, hence unset it for
	# the tests temporarily.
	env -u A MAKEFLAGS= \
		"${S}"/bmake -r -m / TEST_MAKE="${S}"/bmake test || die "tests compilation failed"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	FORCE_BSD_MK=1 SYS_MK_DIR=. \
		sh ../mk/install-mk -v -m 644 "${ED}"/usr/share/mk/${PN} \
		|| die "failed to install mk files"
}
