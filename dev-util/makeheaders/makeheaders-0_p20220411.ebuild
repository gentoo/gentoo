# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs
# https://fossil-scm.org/home/finfo?name=tools/makeheaders.c
ARTIFACT_C="ca90c1e2460d79e48f97c2aac60a39bcb8024e394de7cff5164c9dcbc96ce529"
# https://fossil-scm.org/home/finfo?name=tools/makeheaders.html
ARTIFACT_HTML="262696252dc50250c896c90cc240dcd946614b9c7727902aa7606640507e9231"

DESCRIPTION="Tool that automatically generates .h files for a C or C++ programming project"
HOMEPAGE="https://www.hwaci.com/sw/mkhdr/"

SRC_URI="
	https://fossil-scm.org/home/raw/${ARTIFACT_C}?at=makeheaders.c -> makeheaders-${PV}.c
	https://fossil-scm.org/home/raw/${ARTIFACT_HTML}?at=makeheaders.html  -> makeheaders-${PV}.html
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

HTML_DOCS=( "makeheaders.html" )

src_unpack() {
	mkdir "${S}" || die
	cp "${DISTDIR}"/makeheaders-${PV}.c "${S}/makeheaders.c" || die
	cp "${DISTDIR}"/makeheaders-${PV}.html "${S}/makeheaders.html" || die
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -o makeheaders makeheaders.c || die
}

src_install() {
	dobin makeheaders

	einstalldocs
}
