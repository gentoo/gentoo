# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Tracks your time from the command line, and generates reports"
HOMEPAGE="https://timewarrior.net"
SRC_URI="https://github.com/GothenburgBitFactory/timewarrior/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	mycmakeargs=(
		-DCMAKE_BUILD_TYPE=release
		-DTIMEW_DOCDIR=share/doc/"${PF}"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc -r ext
	docompress -x /usr/share/doc/${PF}/ext/{on-modify.timewarrior,README}
}

pkg_postinst() {
	elog "To integrate timewarrior with taskwarrior, issue the following commands:"
	elog "cp /usr/share/doc/${PF}/ext/on-modify.timewarrior ~/.task/hooks/"
	elog "chmod +x ~/.task/hooks/on-modify.timewarrior"
	elog "see https://timewarrior.net/docs/taskwarrior.html"
}
