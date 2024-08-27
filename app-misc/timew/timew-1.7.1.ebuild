# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake shell-completion

DESCRIPTION="Tracks your time from the command line, and generates reports"
HOMEPAGE="https://timewarrior.net"
SRC_URI="https://github.com/GothenburgBitFactory/timewarrior/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

src_configure() {
	local mycmakeargs=(
		-DTIMEW_DOCDIR=share/doc/${PF}
	)

	cmake_src_configure
}

src_test() {
	cd "${WORKDIR}"/"${P}"_build || die

	eninja test
}

src_install() {
	cmake_src_install

	dodoc -r ext
	docompress -x /usr/share/doc/${PF}/ext/{on-modify.timewarrior,README}

	doman doc/man1/*.1
	doman doc/man7/*.7
	newbashcomp completion/timew-completion.bash timew
	dofishcomp completion/timew.fish
}

pkg_postinst() {
	elog "To integrate timewarrior with taskwarrior, issue the following commands:"
	elog "cp /usr/share/doc/${PF}/ext/on-modify.timewarrior ~/.task/hooks/"
	elog "chmod +x ~/.task/hooks/on-modify.timewarrior"
	elog "see https://timewarrior.net/docs/taskwarrior/"
}
