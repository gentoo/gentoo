# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PV="${PV/./_}"

DESCRIPTION="CPU testing utilities in optimized assembler for maximum loading"
HOMEPAGE="https://web.archive.org/web/20110623074500/pages.sbcglobal.net/redelm/"
SRC_URI="https://dev.gentoo.org/~conikost/files/${PN}_${MY_PV}_tar.gz -> ${P}.tar.gz"

KEYWORDS="-* amd64 arm x86"
LICENSE="GPL-2"
SLOT="0"

PATCHES=( "${FILESDIR}/${P}-variables.patch" )

QA_FLAGS_IGNORED="
	usr/bin/burnBX
	usr/bin/burnK6
	usr/bin/burnK7
	usr/bin/burnMMX
	usr/bin/burnP5
	usr/bin/burnP6
"

QA_TEXTRELS="${QA_FLAGS_IGNORED}"

src_prepare() {
	default

	# Respect users compiler and users CFLAGS and LDFLAGS on x86/amd64
	# Must be always compiled in 32-bit on amd64 arch
	# See https://bugs.gentoo.org/65719
	sed -i -e 's/gcc -s/$(CC) $(CFLAGS) -m32 $(LDFLAGS)/' Makefile || die

	# Respect users compiler, CFLAGS and LDFLAGS on arm
	sed -i -e '/CC :=/d' -e 's/^.*-mfloat-abi=softfp/	$(CC) $(CFLAGS) -nostdlib $(LDFLAGS)/' ARM/Makefile || die
}

src_compile() {
	if use arm; then
		cd "${S}"/ARM || die
	fi

	default
}

src_install() {
	if use arm; then
		dobin ARM/burnCortexA8 ARM/burnCortexA9
		local DOCS=( "ARM/Design" "README" )
	else
		dobin burnBX burnK6 burnK7 burnMMX burnP5 burnP6
		local DOCS=( "Design" "README" )
	fi

	einstalldocs
}
