# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit flag-o-matic eutils

DESCRIPTION="Hercules System/370, ESA/390 and zArchitecture Mainframe Emulator"
HOMEPAGE="http://www.hercules-390.eu/"
SRC_URI="http://downloads.hercules-390.eu/${P}.tar.gz"

LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86 ~x64-macos ~x86-macos"
IUSE="bzip2 custom-cflags +suid"

RDEPEND="bzip2? ( app-arch/bzip2 )
	net-libs/libnsl:0
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.09-aliasing.patch

	# The local modules need local libs, so when doing a parallel install
	# of the modules and libs breaks during relinking.  Force the libs to
	# install first, and then the modules that use those libs.  #488126
	echo "install-modexecLTLIBRARIES: install-libLTLIBRARIES" >> Makefile.in
}

src_configure() {
	use custom-cflags || strip-flags
	ac_cv_lib_bz2_BZ2_bzBuffToBuffDecompress=$(usex bzip2) \
	econf \
		$(use_enable bzip2 cckd-bzip2) \
		$(use_enable bzip2 het-bzip2) \
		$(use_enable suid setuid-hercifc) \
		--enable-custom="Gentoo ${PF}.ebuild" \
		--disable-optimization
}

src_install() {
	default
	insinto /usr/share/hercules
	doins hercules.cnf
	dodoc README.* RELEASE.NOTES
	dohtml -r html
}
