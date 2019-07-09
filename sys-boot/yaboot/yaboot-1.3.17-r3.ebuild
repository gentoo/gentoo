# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

# yaboot is sensitive to external libc dependencies
# of e2fsprogs. Pin to known working versions.
# As a bonus we can control CFLAGS used to build e2fsprogs.
# See compile_bundled_e2fsprogs() below and https://bugs.gentoo.org/641560
E2FS_P="e2fsprogs-1.42.13"

DESCRIPTION="PPC Bootloader"
HOMEPAGE="http://yaboot.ozlabs.org"
SRC_URI="
	http://yaboot.ozlabs.org/releases/${P}.tar.gz
	mirror://sourceforge/e2fsprogs/${E2FS_P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~ppc -ppc64"
IUSE="ibm"

DEPEND="
	sys-apps/powerpc-utils
"
RDEPEND="!sys-boot/yaboot-static
	!ibm? (
		sys-fs/hfsutils
		sys-fs/hfsplusutils
		sys-fs/mac-fdisk
	)"

PATCHES=(
	# dual boot patch
	"${FILESDIR}/yabootconfig-1.3.13.patch"
	"${FILESDIR}/chrpfix.patch"
	"${FILESDIR}/${P}-nopiessp-gcc4.patch"
	"${FILESDIR}/${PN}-stubfuncs.patch"

	# Fix the devspec path on newer kernels
	"${FILESDIR}/new-ofpath-devspec.patch"
)

src_prepare() {
	# has to be copied before 'new-ofpath-devspec'
	cp "${FILESDIR}/new-ofpath" "${S}/ybin/ofpath" || die
	default

	pushd "${WORKDIR}/${E2FS_P}"
	eapply "${FILESDIR}"/e2fsprogs-1.42.13-sysmacros.h.patch
	popd

	# No need to hardcode this path -- the compiler already knows to use it.
	# Error only on real errors, for prom printing format compile failure.
	sed -i \
		-e 's:-I/usr/include::' \
		-e 's:-Werror:-Wno-error:g' \
		Makefile || die

	# We'll install bundled libext2fs.a here
	DEPS_DIR="${T}"/bundled-deps
	export DEPS_DIR
}

src_configure() {
	# ld.gold fails to link yaboot as:
	#  sorry, I can't find space in second/yaboot.chrp to put the note
	# bug #678710
	tc-ld-disable-gold

	pushd "${WORKDIR}/${E2FS_P}" || die
	econf \
		--enable-libblkid \
		--enable-libuuid \
		--disable-fsck \
		--disable-quota
	popd

	default
}

src_compile() {
	# Note: we use unmodified host's CFLAGS to build depends.
	emake -C "${WORKDIR}/${E2FS_P}" V=1
	# install-libs to install libext2fs.a for yaboot to statically link against
	emake -C "${WORKDIR}/${E2FS_P}" DESTDIR="${DEPS_DIR}" install-libs V=1

	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
	# -std=gnu90 is needed to preserve 'inline' semantics
	# of pre-c99 (always-inline) to avoid duplicate symbol
	# definition, bug #641560.
	# -L${deps_prefix}/usr/lib is needed to inject known
	# working libext2fs.a as yaboot bundles header overrides
	# that assume matcking implementation. System's version
	# frequently does not work like in bug #641560.
	emake \
		PREFIX=/usr \
		MANDIR=share/man \
		CC="$(tc-getCC) -std=gnu90" \
		LD="$(tc-getLD) -L${DEPS_DIR}/usr/lib"
}

src_install() {
	sed -i -e 's/\/local//' etc/yaboot.conf || die
	emake \
		ROOT="${D}" \
		PREFIX=/usr \
		MANDIR=share/man \
		CC="$(tc-getCC) -std=gnu90" \
		LD="$(tc-getLD) -L${DEPS_DIR}/usr/lib" \
		\
		install
	mv "${ED}"/etc/yaboot.conf{,.sample} || die
}
