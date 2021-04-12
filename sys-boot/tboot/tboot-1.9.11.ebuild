# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic mount-boot

DESCRIPTION="Performs a measured and verified boot using Intel Trusted Execution Technology"
HOMEPAGE="https://sourceforge.net/projects/tboot/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="custom-cflags libressl selinux"

# requires patching the kernel src
RESTRICT="test"

DEPEND="app-crypt/trousers
app-crypt/tpm-tools
!libressl? ( dev-libs/openssl:0=[-bindist] )
libressl? ( dev-libs/libressl:0= )"

RDEPEND="${DEPEND}
sys-boot/grub:2
selinux? ( sec-policy/selinux-tboot )"

DOCS=( README COPYING CHANGELOG )
PATCHES=( "${FILESDIR}/${PN}-1.9.11-genkernel-path.patch" )

src_prepare() {
	sed -i 's/ -Werror//g' Config.mk || die
	sed -i 's/^INSTALL_STRIP = -s$//' Config.mk || die # QA Errors

	default
}

src_compile() {
	use custom-cflags && export TBOOT_CFLAGS=${CFLAGS} || unset CCASFLAGS CFLAGS CPPFLAGS LDFLAGS

	if use amd64; then
		export MAKEARGS="TARGET_ARCH=x86_64"
	else
		export MAKEARGS="TARGET_ARCH=i686"
	fi

	default
}

src_install() {
	emake DISTDIR="${D}" install

	dodoc "${DOCS[@]}"
	dodoc docs/*.txt lcptools/*.pdf

	cd "${ED}"
	mkdir -p usr/lib/tboot/ || die
	mv boot usr/lib/tboot/ || die
}

pkg_postinst() {
	cp "${ROOT}/usr/lib/tboot/boot/*" "${ROOT}/boot/" || die

	ewarn "Please remember to download the SINIT AC Module relevant"
	ewarn "for your platform from:"
	ewarn "http://software.intel.com/en-us/articles/intel-trusted-execution-technology/"
}
