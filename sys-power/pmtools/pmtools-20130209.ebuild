# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Collection of tools for ACPI and power management"
HOMEPAGE="https://github.com/anyc/pmtools/"
SRC_URI="https://github.com/anyc/pmtools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

# dev-lang/perl - RDEPEND for the pmtest tooling, which only works on much older kernels.
RDEPEND="
	>=sys-power/iasl-20090521
"

PATCHES=(
	# All merged upstream in 20230209
	#"${FILESDIR}"/${PN}-20100123-acpixtract-pmtools.patch
	#"${FILESDIR}"/${PN}-20100123-madt.patch
	#"${FILESDIR}"/${PN}-20071116-64bit.patch
	#"${FILESDIR}"/${PN}-20101124-cflags-ldflags.patch

	# New patches
	"${FILESDIR}"/pmtools-20110323-r2-types.patch
)

src_prepare() {
	default

	# update version info
	sed -i -e "s|20060324|20110323|" acpixtract/acpixtract.c || die

	strip-unsupported-flags
}

src_compile() {
	# respect user's LDFLAGS
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	newbin acpidump/acpidump acpidump-pmtools
	newbin acpixtract/acpixtract acpixtract-pmtools
	dobin madt/madt

	dodoc README madt/README.madt
	use doc && dodoc madt/APIC*
}
