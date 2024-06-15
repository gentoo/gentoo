# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fcaps

DESCRIPTION="The SoftDevLabs (SDL) version of the Hercules 4.x Hyperion Emulator"
HOMEPAGE="https://sdl-hercules-390.github.io/html/"
SRC_URI="https://github.com/SDL-Hercules-390/hyperion/archive/refs/tags/Release_${PV/.0/}.tar.gz -> ${P/.0/}.tar.gz"

S="${WORKDIR}/hyperion-Release_${PV/.0/}"
LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
# In theory USE=object-rexx and USE=regina-rexx are not mutually-exclusive.
# In practice they functionally are as the Gentoo packages conflict, and
# additionally Hercules only supports calling out to one of them at runtime,
# controlled by the HREXX_PACKAGE environment variable.
IUSE="bzip2 debug object-rexx regina-rexx test"
RESTRICT="!test? ( test )"
FILECAPS=(
	-M 755 cap_sys_nice\=eip usr/bin/hercules --
	-M 755 cap_sys_nice\=eip usr/bin/herclin --
	-M 755 cap_net_admin+ep usr/bin/hercifc
)

COMMON_DEPEND="
	dev-libs/libltdl
	net-libs/libnsl:0
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	object-rexx? ( dev-lang/oorexx )
	regina-rexx? ( dev-lang/regina-rexx )"
RDEPEND="
	!app-emulation/hercules
	!app-arch/tapeutils
	${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	~app-emulation/hercules-sdl-crypto-${PV}
	~app-emulation/hercules-sdl-decnumber-${PV}
	~app-emulation/hercules-sdl-softfloat-${PV}
	~app-emulation/hercules-sdl-telnet-${PV}"
# Neither package support needs to be compiled-in for tests,
# but the "rexx" command needs to be available
BDEPEND="test? ( || ( dev-lang/regina-rexx dev-lang/oorexx ) )"

PATCHES=(
	"${FILESDIR}/${PN}-4.4.1-htmldir.patch"
	"${FILESDIR}/${PN}-4.7.0-backport-pr658.patch"
)

src_prepare() {
	rm -rf crypto decNumber SoftFloat telnet || die
	sed -i 's#/lib${hc_cv_pkg_lib_subdir}#/lib#g' configure.ac || die
	sed -i 's#_pkgname}${hc_cv_pkg_lib_suffix}#_pkgname}#g' configure.ac || die

	default
	eautoreconf
}

src_configure() {
	local -x ac_cv_lib_bz2_BZ2_bzBuffToBuffDecompress=$(usex bzip2)
	econf \
		$(use_enable bzip2 cckd-bzip2) \
		$(use_enable bzip2 het-bzip2) \
		$(use_enable object-rexx) \
		$(use_enable regina-rexx) \
		$(use_enable debug) \
		--enable-custom="Gentoo ${PF}.ebuild" \
		--disable-optimization \
		--disable-setuid-hercifc \
		--disable-capabilities \
		--enable-ipv6 \
		--enable-enhanced-configincludes \
		--disable-fthreads \
		--enable-shared \
		--enable-automatic-operator \
		--enable-extpkgs="${SYSROOT}/usr/$(get_libdir)/${PN}"
}

src_install() {
	default
	dodoc RELEASE.NOTES

	insinto /usr/share/hercules
	doins hercules.cnf

	# No static archives.  Have to leave .la files for modules. #720342
	find "${ED}/usr/$(get_libdir)" -name "*.la" -delete || die
}
