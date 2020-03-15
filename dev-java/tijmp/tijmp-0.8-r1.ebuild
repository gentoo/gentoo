# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools java-pkg-2

DESCRIPTION="Java Memory Profiler"
HOMEPAGE="http://www.khelekore.org/jmp/tijmp/"
SRC_URI="http://www.khelekore.org/jmp/tijmp/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6"

PATCHES=(
	"${FILESDIR}/${PN}-jni.h.patch"
	"${FILESDIR}/${P}-respect-javacflags.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" jardir="/usr/share/${PN}/lib/" install
	java-pkg_regjar "${D}/usr/share/${PN}/lib/${PN}.jar"
	java-pkg_regso "${D}/usr/$(get_libdir)/lib${PN}.so"

	cat > "${T}/${PN}" <<- "EOF" || die
#!/usr/bin/env bash
java -Dtijmp.jar="$(java-config -p tijmp)" -agentlib:tijmp "${@}"
EOF
	dobin "${T}/${PN}"
}

pkg_postinst() {
	einfo "For your convenience, ${PN} wrapper can be used to run java"
	einfo "with profiling. Just use it in place of the 'java' command."
}
