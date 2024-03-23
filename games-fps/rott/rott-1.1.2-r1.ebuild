# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Rise of the Triad for Linux!"
HOMEPAGE="https://www.icculus.org/rott/"
SRC_URI="https://www.icculus.org/rott/releases/${P}.tar.gz
	demo? ( http://filesingularity.timedoctor.org/swdata.zip )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="demo"

RDEPEND="
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${P}/rott"

src_prepare() {
	default

	sed -i \
		-e '/^CC =/d' \
		Makefile || die "sed failed"
	emake clean
}

src_compile() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/858758
	#
	# The upstream homepage notes that you should send bug reports and feature
	# requests to your distro. Rationale: "1.1.2 contains all the debian
	# patches from the previous 2.5 years" and "1.1.1. contains all the debian
	# and fedora patches that accumulated during the past year."
	#
	# This is an interesting collaborative model that unfortunately means there
	# will be NO bug report.
	filter-lto

	tc-export CC
	emake -j1 \
		EXTRACFLAGS="${CFLAGS} -DDATADIR=\\\"/usr/share/${PN}/\\\"" \
		SHAREWARE=$(usex demo "1" "0")
}

src_install() {
	dobin rott
	dodoc ../doc/*.txt ../README
	doman ../doc/rott.6
	if use demo ; then
		cd "${WORKDIR}" || die
		insinto /usr/share/${PN}
		doins *.dmo huntbgin.* remote1.rts
	fi
}

pkg_postinst() {
	if ! use demo ; then
		elog "To play the full version, just copy the"
		elog "data files to /usr/share/${PN}/"
	fi
}
