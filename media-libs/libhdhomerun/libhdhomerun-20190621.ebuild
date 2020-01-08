# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="SiliconDust HDHomeRun Utilties"
HOMEPAGE="https://www.silicondust.com/support/linux/"
SRC_URI="https://download.silicondust.com/hdhomerun/${PN}_${PV}.tgz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${PV}-use_shared_library.patch"
)

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	#Remove forced optimization from Makefile
	sed -i 's:-O2::' Makefile || die "Was the Makefile changed?"
}

src_compile() {
	emake CC=$(tc-getCC) STRIP=:
}

src_install() {
	dobin hdhomerun_config
	dolib.so libhdhomerun.so

	insinto /usr/include/hdhomerun
	doins *.h
}
