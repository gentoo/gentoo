# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mount-boot toolchain-funcs

DESCRIPTION="Performs a measured and verified boot using Intel Trusted Execution Technology"
HOMEPAGE="https://sourceforge.net/projects/tboot/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="custom-cflags selinux"

# requires patching the kernel src
RESTRICT="test"

DEPEND="dev-libs/openssl:0=[-bindist(-)]"

RDEPEND="${DEPEND}
	sys-boot/grub:2
	selinux? ( sec-policy/selinux-tboot )"

DOCS=( README.md COPYING CHANGELOG )
PATCHES=( "${FILESDIR}/${PN}-1.10.3-disable-Werror.patch"
	  "${FILESDIR}/${PN}-1.10.3-disable-strip.patch"
	  "${FILESDIR}/${PN}-1.10.3-dont-call-toolchain-directly.patch"
	  "${FILESDIR}/${PN}-1.10.5-fix-pconf-element.patch" )

pkg_setup() {
	if tc-is-clang; then
		eerror "tboot is a freestanding application that uses gcc"
		eerror "extensions in fundemental ways, include VLAIS"
		eerror "(Variable Length Arrays in Structs) and will not"
		eerror "compile with clang witout upstream action"
		die "Cannot compile with clang. See bug #832020"
	fi
}

src_configure() {
	tc-export AS LD CC CPP AR RANLIB NM OBJCOPY OBJDUMP STRIP

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
	dodoc docs/*.{txt,md}

	cd "${ED}" || die
	mkdir -p usr/lib/tboot/ || die
	mv boot usr/lib/tboot/ || die
}

pkg_postinst() {
	cp "${ROOT}/usr/lib/tboot/boot/"* "${ROOT}/boot/" || die

	ewarn "Please remember to download the SINIT AC Module relevant"
	ewarn "for your platform from:"
	ewarn "http://software.intel.com/en-us/articles/intel-trusted-execution-technology/"
}
