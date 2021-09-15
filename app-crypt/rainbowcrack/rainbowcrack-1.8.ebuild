# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit wrapper

DESCRIPTION="Hash cracker that precomputes plaintext - ciphertext pairs in advance"
HOMEPAGE="https://project-rainbowcrack.com/"
SRC_URI="https://project-${PN}.com/${P}-linux64.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""

RESTRICT="bindist mirror" #444426

RAINBOW_DESTDIR="opt/${PN}"

QA_FLAGS_IGNORED="${RAINBOW_DESTDIR}/.*"
QA_PRESTRIPPED="${RAINBOW_DESTDIR}/.*"

BDEPEND="app-arch/unzip"

DOCS=(
	readme.txt
)

S="${WORKDIR}"/${P}-linux64

# rainbowcrack-1.8 zipfiles, including the ones for Linux, use backslashes as path separators.
# unzip handles it just fine but produces a warning, the side effect of which is that it exits
# with code 1 rather than 0.
# Don't bother with iterating over A, we already assume the file to be a .zip so we might as well
# assume there is only one.
src_unpack() {
	unzip -qo "${DISTDIR}/${A}"
	local unzip_retval="${?}"
	case "${unzip_retval}" in
		0|1)
			;;
		*)
			die "Failed to unpack the source archive"
			;;
	esac
}

src_install() {
	einstalldocs

	local bin bins="
		rcrack
		rt2rtc
		rtc2rt
		rtgen
		rtmerge
		rtsort
	"

	exeinto "/${RAINBOW_DESTDIR}"
	doexe alglib0.so ${bins}

	for bin in ${bins}; do
		make_wrapper ${bin} ./${bin} "/${RAINBOW_DESTDIR}" "/${RAINBOW_DESTDIR}"
	done

	insinto "/${RAINBOW_DESTDIR}"
	doins charset.txt
}
